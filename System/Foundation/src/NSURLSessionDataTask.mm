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
#import "NSURLSessionTask-Internal.h"

@interface NSURLSessionDataTask () {
    bool _shouldCache;
}
@end

@implementation NSURLSessionDataTask
- (void)_promoteToDownloadTask {
    NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)_storeDataInCache {
    // use accumulated data
    NSCachedURLResponse* proposedCachedURLResponse = nil;

    auto continuation = ^(NSCachedURLResponse* sessionProposedCachedURLResponse) {
        // cache the response!
    };

    [self._taskDelegate dataTask:self willCacheResponse:proposedCachedURLResponse completionHandler:continuation];
}

- (void)_updateWithURLResponse:(NSURLResponse*)response {
    [super _updateWithURLResponse:response];

    auto continuation = ^(NSURLSessionResponseDisposition disposition) {
        switch (disposition) {
            case NSURLSessionResponseAllow:
                return;
            case NSURLSessionResponseCancel:
                [self cancel];
                break;
            case NSURLSessionResponseBecomeDownload:
                [self _promoteToDownloadTask];
                break;
        }
    };
    [self._taskDelegate dataTask:self didReceiveResponse:response completionHandler:continuation];

    _shouldCache = (self.currentRequest.cachePolicy != NSURLCacheStorageNotAllowed);
}

- (void)_didReceiveData:(NSData*)data {
    if (!self.response) {
        // TODO: Some of our URL machinery will leak data before a redirect
        // we don't want to count that data.
        return;
    }

    [super _didReceiveData:data];
    [self._taskDelegate dataTask:self didReceiveData:data];

    if (_shouldCache) {
        // accumulate data
    }
}

- (void)_didFinishLoading {
    if (_shouldCache) {
        [self _storeDataInCache];
    }

    [super _didFinishLoading];
}

@end
