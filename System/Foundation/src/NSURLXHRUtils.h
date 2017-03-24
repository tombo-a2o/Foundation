#import <Foundation/NSObjCRuntime.h>

@class NSURLRequest, NSHTTPURLResponse, NSData;

FOUNDATION_EXPORT int __nsurl_xhrCreateAndOpen(NSURLRequest *request, BOOL async);
FOUNDATION_EXPORT NSHTTPURLResponse *__nsurl_createResponseFromXhr(int xhr, NSURLRequest *request);
FOUNDATION_EXPORT NSData *__nsurl_createDataFromXhr(int xhr);
