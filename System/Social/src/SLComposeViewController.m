#import <Social/SLComposeViewController.h>

NSString *const SLServiceTypeFacebook = @"facebook";
NSString *const SLServiceTypeTwitter = @"twitter";
NSString *const SLServiceTypeSinaWeibo = @"sinaWeibo";
NSString *const SLServiceTypeTencentWeibo = @"tencentWeibo";

@implementation SLComposeViewController

+ (SLComposeViewController *)composeViewControllerForServiceType:(NSString *)serviceType
{
    SLComposeViewController *controller = [[SLComposeViewController alloc] init];
    return controller;
}

+ (BOOL)isAvailableForServiceType:(NSString *)serviceType
{
    return [serviceType isEqualToString:SLServiceTypeFacebook] || [serviceType isEqualToString:SLServiceTypeTwitter];
}

- (BOOL)setInitialText:(NSString *)text
{
    return NO;
}

- (BOOL)addImage:(UIImage *)image
{
    return NO;
}

- (BOOL)removeAllImages
{
    return NO;
}

- (BOOL)addURL:(NSURL *)url
{
    return NO;
}

- (BOOL)removeAllURLs
{
    return NO;
}
@end
