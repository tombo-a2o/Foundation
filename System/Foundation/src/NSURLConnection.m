//
//  NSURLConnection.m
//  Foundation
//
//  Copyright (c) 2014 Apportable. All rights reserved.
//  Copyright (c) 2014-2017 Tombo Inc. All rights reserved.
//

#import <Foundation/NSURLConnection.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSBundle.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSURL.h>
#import <Foundation/NSData.h>
#import <Foundation/NSError.h>
#import <Foundation/NSURLCredential.h>
#import <Foundation/NSURLRequest.h>
#import <Foundation/NSURLResponse.h>
#import <Foundation/NSRunLoop.h>
#import <Foundation/NSStream.h>
#import <Foundation/NSOperation.h>
#import <Foundation/NSURLProtocol.h>
#import "NSURLAuthenticationChallengeInternal.h"
#import "NSURLProtectionSpaceInternal.h"
#import "NSURLProtocolInternal.h"
#import "NSURLRequestInternal.h"
#import "NSURLResponseInternal.h"
#import "NSURLCacheInternal.h"
#import <Foundation/NSObjectInternal.h>
#import <CFNetwork/CFURLConnection.h>
#import <CoreFoundation/CFData.h>
#import <Foundation/NSURLError.h>
#import <emscripten.h>
#import <emscripten/xhr.h>
#import "NSURLXHRUtils.h"

@interface NSURLConnection ()
@property(readwrite, copy) NSURLRequest *originalRequest;
@property(readwrite, copy) NSURLRequest *currentRequest;
@property(nonatomic, assign) id<NSURLConnectionDelegate> delegate;
@property(nonatomic, assign) NSRunLoop *runLoop;
@property(nonatomic, assign) NSString *mode;
@property(nonatomic, assign) int xhr;
@property(nonatomic, assign) int readyState;
@end

@implementation NSURLConnection

+ (NSURLConnection*)connectionWithRequest:(NSURLRequest *)request delegate:(id<NSURLConnectionDelegate>)delegate
{
    return [[[NSURLConnection alloc] initWithRequest:request delegate:delegate startImmediately:YES] autorelease];
}

+ (BOOL)canHandleRequest:(NSURLRequest *)request
{
    NSString *scheme = request.URL.scheme;
    return [scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"];
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id<NSURLConnectionDelegate>)delegate startImmediately:(BOOL)startImmediately
{
    if(![NSURLConnection canHandleRequest:request]) return nil;

    self = [super init];
    if(!self) return nil;

    self.delegate = delegate;
    self.originalRequest = request;
    self.currentRequest = request;
    self.runLoop = [NSRunLoop currentRunLoop];
    self.mode = NSDefaultRunLoopMode;

    if(startImmediately) [self start];

    return self;
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id<NSURLConnectionDelegate>)delegate
{
    return [self initWithRequest:request delegate:delegate startImmediately:YES];
}

- (void)dealloc
{
    [self.originalRequest release];
    [self.currentRequest release];
    [super dealloc];
}

- (void)didReceiveResponse:(NSHTTPURLResponse*)response {
    if([self.delegate respondsToSelector:@selector(connection:didReceiveResponse:)]) {
        [(id<NSURLConnectionDataDelegate>)self.delegate connection:self didReceiveResponse:response];
    }
}

- (void)didReceiveData:(NSData*)data {
    if([self.delegate respondsToSelector:@selector(connection:didReceiveData:)]) {
        [(id<NSURLConnectionDataDelegate>)self.delegate connection:self didReceiveData:data];
    }
}

- (void)didFinishLoading:(id)dummy {
    if([self.delegate respondsToSelector:@selector(connectionDidFinishLoading:)]) {
        [(id<NSURLConnectionDataDelegate>)self.delegate connectionDidFinishLoading:self];
    }
}

- (void)didFailWithError:(NSError*)error {
    if([self.delegate respondsToSelector:@selector(connection:didFailWithError:)]) {
        [(id<NSURLConnectionDataDelegate>)self.delegate connection:self didFailWithError:error];
    }
}

static void onloadCallback(void *ctx) {
    NSURLConnection *connection= (NSURLConnection*)ctx;
    int xhr = connection.xhr;
    int currentState = connection.readyState;
    int newState = _xhr_get_ready_state(xhr);
    connection.readyState = newState;

    if(currentState < 2 && newState >= 2) {
        NSHTTPURLResponse *response= __nsurl_createResponseFromXhr(xhr, connection.currentRequest);
        [connection performSelector:@selector(didReceiveResponse:) withObject:response];
    }
    if(currentState < 3 && newState >= 3) {
        // Return all data at once
    }
    if(currentState < 4 && newState >= 4) {
        NSData *data = __nsurl_createDataFromXhr(xhr);
        [connection performSelector:@selector(didReceiveData:) withObject:data];
        [connection performSelector:@selector(didFinishLoading:) withObject:nil];
        [connection release];
    }
}

static void onerrorCallback(void *ctx) {
    NSURLConnection *connection= (NSURLConnection*)ctx;

    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUnknown userInfo:nil];
    [connection performSelector:@selector(didFailWithError:) withObject:error];
    [connection release];
}

- (void)start
{
    if(self.xhr) return;

    [self retain];
    int xhr = self.xhr = __nsurl_xhrCreateAndOpen(self.currentRequest, YES);
    self.readyState = 0;
    _xhr_set_onload(xhr, dispatch_get_current_queue(), self, onloadCallback);
    _xhr_set_onerror(xhr, dispatch_get_current_queue(), self, onerrorCallback);
    NSData *body = self.currentRequest.HTTPBody;
    _xhr_send(xhr, body.bytes, body.length);
}

- (void)cancel
{
    assert(0);
}

- (void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode
{
    _runLoop = aRunLoop;
}

- (void)unscheduleFromRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode
{
    assert(0);
}

- (void)setDelegateQueue:(NSOperationQueue*)queue
{
    assert(0);
}

@end

@implementation NSURLConnection (NSURLConnectionSynchronousLoading)

+ (NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response error:(NSError **)error
{
    if ([request URL] == nil)
    {
        if (error)
        {
            *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadURL userInfo:nil];
        }

        return nil;
    }

    int xhr = __nsurl_xhrCreateAndOpen(request, NO);
    NSData *body = request.HTTPBody;
    _xhr_send(xhr, body.bytes, body.length); // block

    int status = _xhr_get_status(xhr);

    if(status == 0) {
        // connection, dns, timeout, etc...
        if(error) {
            *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUnknown userInfo:nil];
        }
        return nil;
    }

    //length = _xhr_get_status_text(xhr, &data);
    //NSString *statusText = [[NSString alloc] initWithBytesNoCopy:data length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];

    if(response) {
        *response = __nsurl_createResponseFromXhr(xhr, request);
    }

    NSData *data = __nsurl_createDataFromXhr(xhr);

    return data;
}

@end

@implementation NSURLConnection (NSURLConnectionQueuedLoading)

+ (void)sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler
{
    if ([request URL] == nil)
    {
        if (handler)
        {
            handler(nil, nil, [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadURL userInfo:nil]);
        }

        return;
    }

    NSAssert(0, @"%s is not implemented", __FUNCTION__);
#if 0
    CFMutableURLRequestRef req = CFURLRequestCreateMutableCopy(kCFAllocatorDefault, [request _CFURLRequest]);
    CFURLConnectionSendAsynchronousRequest(req, ^(CFURLResponseRef response, CFDataRef data, CFErrorRef error) {
        NSURLResponse *resp = [NSHTTPURLResponse _responseWithCFURLResponse:response];
        NSData *d = (NSData *)data;
        NSError *err = (NSError *)error;
        [queue addOperationWithBlock:^{
            handler(resp, d, err);
        }];
    });
    CFRelease(req);
#endif
}

@end
