//
//  NSURLConnection.m
//  Foundation
//
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/NSURLConnection.h>
#import <Foundation/NSArray.h>
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
#import "NSURLConnectionInternal.h"
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

extern int _xhr_create(void);
extern void _xhr_open(int xhr, const char *method, const char *url, int async, const char *user, const char *password);
extern void _xhr_set_onload(int xhr, dispatch_queue_t queue, void *ctx, void func(void*));
extern void _xhr_set_onerror(int xhr, dispatch_queue_t queue, void *ctx, void func(void*));
extern void _xhr_set_request_header(int xhr, const char *key, const char *value);
extern void _xhr_send(int xhr, const char *data, int length);
extern int _xhr_get_ready_state(int xhr);
extern int _xhr_get_status(int xhr);
extern int _xhr_get_status_text(int xhr, void **text); // return length, text needs to be freed by caller 
extern int _xhr_get_response_text(int xhr, void **data); // return length, data needs to be freed by caller
extern int _xhr_get_all_response_headers(int xhr, void **data); // return length, data needs to be freed by caller

static int xhrCreateAndOpen(NSURLRequest *request, BOOL async) {
    NSString *method = request.HTTPMethod;
    NSURL *url = request.URL;
    NSDictionary *headers = request.allHTTPHeaderFields;

    int xhr = _xhr_create();
    _xhr_open(xhr, [method UTF8String], [url.absoluteString UTF8String], async ? 1 : 0, [url.user UTF8String], [url.password UTF8String]);
    for(NSString *key in [headers allKeys]) {
        NSString *value = [headers objectForKey:key];
        _xhr_set_request_header(xhr, [key UTF8String], [value UTF8String]);
    }
    return xhr;
}

static NSHTTPURLResponse *createResponseFromXhr(int xhr, NSURLRequest *request) {
    void *data;
    int length = _xhr_get_all_response_headers(xhr, &data);
    NSString *headerText = [[NSString alloc] initWithBytesNoCopy:data length:length-1 encoding:NSASCIIStringEncoding freeWhenDone:YES];

    NSMutableDictionary *respHeaders = [[NSMutableDictionary alloc] init];
    NSArray *responseHeaders = [headerText componentsSeparatedByString:@"\r\n"];
    for(NSString *line in responseHeaders) {
        if(line.length == 0) continue;

        NSRange range = [line rangeOfString:@":"];
        assert(range.location != NSNotFound);
        NSString *key = [line substringToIndex:range.location];
        NSString *value = [line substringFromIndex:range.location+2]; // ":" + space
        [respHeaders setObject:value forKey:key];
    }

    int status = _xhr_get_status(xhr);
    return [[NSHTTPURLResponse alloc] initWithURL:request.URL statusCode:status HTTPVersion:@"HTTP/1.1" headerFields:respHeaders];
}

static NSData *createDataFromXhr(int xhr) {
    void *data;
    int length = _xhr_get_response_text(xhr, &data);
    return [NSData dataWithBytesNoCopy:data length:length freeWhenDone:YES]; 
}

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
        NSHTTPURLResponse *response= createResponseFromXhr(xhr, connection.currentRequest);
        [connection performSelector:@selector(didReceiveResponse:) withObject:response];
    }
    if(currentState < 3 && newState >= 3) {
        // Return all data at once
    }
    if(currentState < 4 && newState >= 4) {
        NSData *data = createDataFromXhr(xhr);
        [connection performSelector:@selector(didReceiveData:) withObject:data];
        [connection performSelector:@selector(didFinishLoading:) withObject:nil];
    }
}

static void onerrorCallback(void *ctx) {
    NSURLConnection *connection= (NSURLConnection*)ctx;
    
    NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSURLErrorUnknown userInfo:nil];
    [connection performSelector:@selector(didFailWithError:) withObject:error];
}

- (void)start
{
    int xhr = self.xhr = xhrCreateAndOpen(self.currentRequest, YES);
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

    int xhr = xhrCreateAndOpen(request, NO);
    NSData *body = request.HTTPBody;
    _xhr_send(xhr, body.bytes, body.length); // block
    
    int status = _xhr_get_status(xhr);

    if(status == 0) {
        // connection, dns, timeout, etc...
        *error = [[[NSError alloc] init] autorelease];
        return NULL;
    }

    //length = _xhr_get_status_text(xhr, &data);
    //NSString *statusText = [[NSString alloc] initWithBytesNoCopy:data length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];

    if(response) {
        *response= createResponseFromXhr(xhr, request);
    }

    NSData *data = createDataFromXhr(xhr);

    return [data autorelease];
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
}

@end
