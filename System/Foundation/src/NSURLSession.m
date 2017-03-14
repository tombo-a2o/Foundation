#import <Foundation/NSURLSession.h>

const int64_t NSURLSessionTransferSizeUnknown = -1;

@implementation NSURLSession
+ (NSURLSession *)sessionWithConfiguration:(NSURLSessionConfiguration *)configuration
{
    return nil;
}
@end
@implementation NSURLSessionConfiguration
+ (NSURLSessionConfiguration *)defaultSessionConfiguration
{
    //NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}
+ (NSURLSessionConfiguration *)ephemeralSessionConfiguration
{
    //NSLog(@"*** %s is not implemented", __FUNCTION__);
    return nil;
}
@end
@implementation NSURLSessionTask
@end
