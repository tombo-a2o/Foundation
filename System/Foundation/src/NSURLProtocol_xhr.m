#import <Foundation/Foundation.h>
#import <emscripten/xhr.h>
#import "NSURLXHRUtils.h"

@interface NSURLProtocol_xhr : NSURLProtocol
@property(nonatomic, assign) int xhr;
@property(nonatomic, assign) int readyState;
@end

@implementation NSURLProtocol_xhr
+ (void)load {
    [NSURLProtocol registerClass:self];
}

+ (BOOL)canInitWithRequest:(NSURLRequest*)request {
    NSString *scheme = request.URL.scheme;
    return [scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"];
}

- (instancetype)initWithRequest:(NSURLRequest*)request
                 cachedResponse:(NSCachedURLResponse*)cachedResponse
                         client:(id<NSURLProtocolClient>)client {
    if (self = [super initWithRequest:request cachedResponse:cachedResponse client:client]) {
    }
    return self;
}

static void onloadCallback(void *ctx) {
    NSURLProtocol_xhr *proto = (NSURLProtocol_xhr*)ctx;
    int xhr = proto.xhr;
    int currentState = proto.readyState;
    int newState = _xhr_get_ready_state(xhr);
    proto.readyState = newState;

    if(currentState < 2 && newState >= 2) {
        NSURLRequest *request = proto.request;
        NSHTTPURLResponse *response= __nsurl_createResponseFromXhr(xhr, request);
        int statusCode = response.statusCode;
        if(statusCode >= 300 && statusCode < 400) {
            NSURL *currentUrl = proto.request.URL;
            NSString *location = response.allHeaderFields[@"Location"];

            // TODO return error
            assert(location);

            NSURL *nextUrl = [NSURL URLWithString:location relativeToURL:currentUrl];
            NSMutableURLRequest *nextRequest = [request mutableCopy];
            nextRequest.URL = nextUrl;
            [proto.client URLProtocol:proto wasRedirectedToRequest:nextRequest redirectResponse:response];
            return; // don't call didLoadData and didFinishLoading
        } else {
            [proto.client URLProtocol:proto didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        }
    }
    if(currentState < 3 && newState >= 3) {
        // Return all data at once
    }
    if(currentState < 4 && newState >= 4) {
        NSData *data = __nsurl_createDataFromXhr(xhr);

        [proto.client URLProtocol:proto didLoadData:data];
        [proto.client URLProtocolDidFinishLoading:proto];
        [proto release];
    }
}

static void onerrorCallback(void *ctx) {
    NSURLProtocol_xhr *proto= (NSURLProtocol_xhr*)ctx;

    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUnknown userInfo:nil];
    [proto.client URLProtocol:proto didFailWithError:error];
    [proto release];
}

- (void)startLoading {
    if(_readyState != 0) {
        return;
    }

    NSURLRequest *request = self.request;
    _xhr = __nsurl_xhrCreateAndOpen(request, YES);
    _xhr_set_onload(_xhr, dispatch_get_current_queue(), self, onloadCallback);
    _xhr_set_onerror(_xhr, dispatch_get_current_queue(), self, onerrorCallback);
    NSData *body = request.HTTPBody;
    _xhr_send(_xhr, body.bytes, body.length);
    [self retain];
}

- (void)stopLoading {
    _xhr_abort(_xhr);
    _xhr = 0;
}

@end
