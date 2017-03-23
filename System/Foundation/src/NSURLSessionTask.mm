//******************************************************************************
//
// Copyright (c) 2015 Microsoft Corporation. All rights reserved.
//
// This code is licensed under the MIT License (MIT).
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//******************************************************************************

#import <Foundation/Foundation.h>
#import "NSURLSession-Internal.h"
#import "NSURLSessionTask-Internal.h"
#import "NSURLProtocolInternal.h"
#import <emscripten/xhr.h>
#import "NSURLXHRUtils.h"

const float NSURLSessionTaskPriorityHigh = 1.0f;
const float NSURLSessionTaskPriorityDefault = 0.5f;
const float NSURLSessionTaskPriorityLow = 0.0f;

#pragma region HTTP Status Codes
enum HttpStatus : int {
    PartialContent = 206,
    RangeNotSatisfiableError = 416,
};
#pragma endregion

@interface NSURLSessionTask () {
    NSURLSessionConfiguration* _configuration;
}
@property(nonatomic, assign) int xhr;
@property(nonatomic, assign) int readyState;
@end

@implementation NSURLSessionTask
@synthesize _taskDelegate = _taskDelegate;

- (id)_initWithTaskDelegate:(id<_NSURLSessionTaskDelegate>)taskDelegate
                 identifier:(NSUInteger)identifier
              configuration:(NSURLSessionConfiguration*)configuration
                    request:(NSURLRequest*)request {
    if (self = [super init]) {
        _taskDelegate = [taskDelegate retain];
        _configuration = [configuration retain];

        NSMutableURLRequest* newRequest = [request mutableCopy];

        [newRequest setCachePolicy:configuration.requestCachePolicy];
        [newRequest setTimeoutInterval:configuration.timeoutIntervalForRequest];
        [newRequest setHTTPShouldHandleCookies:configuration.HTTPShouldSetCookies];
        [newRequest setHTTPShouldUsePipelining:configuration.HTTPShouldUsePipelining];
        for (NSString* headerField in configuration.HTTPAdditionalHeaders) {
            [newRequest setValue:configuration.HTTPAdditionalHeaders[headerField] forHTTPHeaderField:headerField];
        }

        // TODO: Propagate all NSURLSessionConfiguration values.
        // Right now, NSURLRequest just doesn't support many of them.

        _currentRequest = newRequest;
        _originalRequest = [newRequest copy];

        _priority = NSURLSessionTaskPriorityDefault;
        _state = NSURLSessionTaskStateSuspended;

        _countOfBytesExpectedToReceive = NSURLSessionTransferSizeUnknown;
        _countOfBytesExpectedToSend = NSURLSessionTransferSizeUnknown;

        _taskIdentifier = identifier;
    }
    return self;
}

/**
 @Status Interoperable
*/
- (void)dealloc {
    [_taskDescription release];
    [_currentRequest release];
    [_originalRequest release];
    [_response release];
    [_error release];
    [_configuration release];
    _xhr_clean(_xhr);
    [super dealloc];
}

/**
 @Status Interoperable
*/
- (id)copyWithZone:(NSZone*)zone {
    return [self retain];
}

- (NSCachedURLResponse*)_cachedResponseFromConfiguration {
    return [_configuration.URLCache cachedResponseForRequest:_currentRequest];
}

- (void)_updateWithURLResponse:(NSURLResponse*)response {
    self.response = response;

    unsigned long long expected = _response.expectedContentLength;
    unsigned long long received = 0;

    // For a ranged HTTP response, the expected content length tells only half the story.
    // If we have resumed a download, we *actually* care about the number of bytes that the
    // ranged response can give us, and no more.
    if ([_response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse* httpResponse = static_cast<NSHTTPURLResponse*>(_response);
        NSString* rangeResponse = [[httpResponse allHeaderFields] objectForKey:@"Content-Range"];
        if ((httpResponse.statusCode == HttpStatus::PartialContent || httpResponse.statusCode == HttpStatus::RangeNotSatisfiableError) &&
            rangeResponse) {
            // Per RFC 7233 section 4.2, a byte-content-range header will always contain FIRST-LAST, and may optionally contain
            // /COMPLETE_LENGTH, but only on 206 (Partial Content) or 416 (Range Not Satisfiable) responses.
            unsigned long long first = 0, last = 0, completeLength = 0;
            NSLog(@"*** %s FIXME", __FUNCTION__);
            // int tokens = sscanf_s([rangeResponse UTF8String], "bytes %llu-%llu/%llu", &first, &last, &completeLength);
            // if (tokens >= 2) { // "bytes" $FIRST "-" $LAST
            //     received = first;
            //     if (tokens >= 3) { // "/" $COMPLETE_LENGTH
            //         expected = completeLength;
            //     } else {
            //         // last is the zero-based index of the last byte the server is including in the response;
            //         // here we add 1 to compensate.
            //         expected = last + 1;
            //     }
            // }
        }
    }

    self.countOfBytesReceived = received;
    self.countOfBytesExpectedToReceive = expected;
}

- (void)_signalCompletionInState:(NSURLSessionTaskState)state withError:(NSError*)error {
    self.error = error;
    self.state = state;

    [_taskDelegate task:self didCompleteWithError:self.error];
    [_taskDelegate release];

    _xhr_clean(_xhr);
    _xhr = 0;
}

/**
 @Status Interoperable
*/
- (void)resume {
    @synchronized(self) {
        if (_state == NSURLSessionTaskStateRunning) {
            return;
        }

        [self _startLoading];
        self.state = NSURLSessionTaskStateRunning;
    }
}

static void onloadCallback(void *ctx) {
    NSURLSessionTask *task= (NSURLSessionTask*)ctx;
    int xhr = task.xhr;
    int currentState = task.readyState;
    int newState = _xhr_get_ready_state(xhr);
    task.readyState = newState;

    if(currentState < 2 && newState >= 2) {
        NSHTTPURLResponse *response= __nsurl_createResponseFromXhr(xhr, task.currentRequest);
        [task _updateWithURLResponse:response];
    }
    if(currentState < 3 && newState >= 3) {
        // Return all data at once
    }
    if(currentState < 4 && newState >= 4) {
        NSData *data = __nsurl_createDataFromXhr(xhr);

        [task _didReceiveData:data];
        [task _didFinishLoading];
        [task release];
    }
}

static void onerrorCallback(void *ctx) {
    NSURLSessionTask *task= (NSURLSessionTask*)ctx;

    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUnknown userInfo:nil];
    [task _didFailWithError:error];
    [task release];
}

- (void)_startLoading {
    if (!_xhr) {
        NSString *scheme = [[_currentRequest URL] scheme];
        if(!([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"])) {
            NSError* error = [NSError
                errorWithDomain:NSCocoaErrorDomain
                           code:0
                       userInfo:@{
                           NSLocalizedDescriptionKey :
                               [NSString stringWithFormat:@"Unable to find a protocol handler for `%@`.", [_currentRequest.URL scheme]],
                       }];
            [self _signalCompletionInState:NSURLSessionTaskStateCompleted withError:error];
            return;
        }
        NSLog(@"%s FIXME use cached response", __FUNCTION__);
        NSCachedURLResponse* cachedResponse = [self _cachedResponseFromConfiguration];

        _xhr = __nsurl_xhrCreateAndOpen(_currentRequest, YES);
        _xhr_set_onload(_xhr, dispatch_get_current_queue(), self, onloadCallback);
        _xhr_set_onerror(_xhr, dispatch_get_current_queue(), self, onerrorCallback);
        NSData *body = _currentRequest.HTTPBody;
        _xhr_send(_xhr, body.bytes, body.length);
        [self retain];
    }
}

/**
 @Status Interoperable
*/
- (void)cancel {
    @synchronized(self) {
        if (_state != NSURLSessionTaskStateRunning) {
            return;
        }

        [self _stopLoading];
    }
    [self _signalCompletionInState:NSURLSessionTaskStateCanceling withError:nil];
}

- (void)_stopLoading {
    _xhr_abort(_xhr);
    _xhr = 0;
}

/**
 @Status Stub
*/
- (void)suspend {
    NSLog(@"*** %s FIXME", __FUNCTION__);
    @synchronized(self) {
        if (_state == NSURLSessionTaskStateSuspended) {
            return;
        }
    }
}

- (void)_didReceiveData:(NSData*)data {
    self.countOfBytesReceived = self.countOfBytesReceived + [data length];
}

- (void)_didFinishLoading {
    [self _signalCompletionInState:NSURLSessionTaskStateCompleted withError:nil];
}

- (void)_didFailWithError:(NSError*)error {
    [self _signalCompletionInState:NSURLSessionTaskStateCompleted withError:error];
}

/**
 @Status Interoperable
*/
- (void)URLProtocol:(NSURLProtocol*)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge {
    auto continuation = ^(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential* credential) {
        switch (disposition) {
            case NSURLSessionAuthChallengeUseCredential:
                [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
                break;
            case NSURLSessionAuthChallengePerformDefaultHandling:
                [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
                break;
            case NSURLSessionAuthChallengeCancelAuthenticationChallenge:
                [challenge.sender cancelAuthenticationChallenge:challenge];
                break;
            case NSURLSessionAuthChallengeRejectProtectionSpace:
                [challenge.sender rejectProtectionSpaceAndContinueWithChallenge:challenge];
                break;
        }
    };
    [_taskDelegate task:self didReceiveChallenge:challenge completionHandler:continuation];
}

/**
 @Status Interoperable
*/
- (void)URLProtocol:(NSURLProtocol*)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge {
    [self cancel];
}

/**
 @Status Interoperable
*/
- (void)URLProtocol:(NSURLProtocol*)connection wasRedirectedToRequest:(NSURLRequest*)request redirectResponse:(NSURLResponse*)response {
    auto continuation = ^(NSURLRequest* sessionNewRequest) {
        @synchronized(self) {
            [self _stopLoading];
            self.currentRequest = sessionNewRequest;
            [self _startLoading];
        }
    };

    [_taskDelegate task:self willPerformHTTPRedirection:(NSHTTPURLResponse*)response newRequest:request completionHandler:continuation];
};

@end
