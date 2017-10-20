#import <Foundation/Foundation.h>
#import <emscripten/xhr.h>

static void setDefaultUserAgent(int xhr) {
    NSString *bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    NSString *bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *userAgent = [NSString stringWithFormat:@"%@/%@ CFNetwork/808.2.16 Darwin/16.3.0", bundleName, bundleVersion];
    _xhr_set_request_header(xhr, "User-Agent", [userAgent UTF8String]);
}

int __nsurl_xhrCreateAndOpen(NSURLRequest *request, BOOL async) {
    NSString *method = request.HTTPMethod;
    NSURL *url = request.URL;
    NSDictionary *headers = request.allHTTPHeaderFields;

    int xhr = _xhr_create();
    _xhr_open(xhr, [method UTF8String], [url.absoluteString UTF8String], async ? 1 : 0, [url.user UTF8String], [url.password UTF8String]);
    _xhr_set_timeout(xhr, 3000);
    setDefaultUserAgent(xhr);
    for(NSString *key in [headers allKeys]) {
        NSString *value = [headers objectForKey:key];
        _xhr_set_request_header(xhr, [key UTF8String], [value UTF8String]);
    }
    return xhr;
}

NSHTTPURLResponse *__nsurl_createResponseFromXhr(int xhr, NSURLRequest *request) {
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

NSData *__nsurl_createDataFromXhr(int xhr) {
    void *data;
    int length = _xhr_get_response_text(xhr, &data);
    return [NSData dataWithBytesNoCopy:data length:length freeWhenDone:YES];
}
