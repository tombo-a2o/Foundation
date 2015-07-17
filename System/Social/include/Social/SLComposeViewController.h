#ifndef SOCIAL_SLComposeViewController
#define SOCIAL_SLComposeViewController

// https://developer.apple.com/library/ios/documentation/NetworkingInternet/Reference/SLComposeViewController_Class/index.html

#import <UIKit/UIViewController.h>
#import <UIKit/UIImage.h>

typedef NS_ENUM (NSInteger, SLComposeViewControllerResult ) {
    SLComposeViewControllerResultCancelled,
    SLComposeViewControllerResultDone 
};

typedef void (^SLComposeViewControllerCompletionHandler) (SLComposeViewControllerResult result);

@interface SLComposeViewController : UIViewController {
}
+ (SLComposeViewController *)composeViewControllerForServiceType:(NSString *)serviceType;
+ (BOOL)isAvailableForServiceType:(NSString *)serviceType;
- (BOOL)setInitialText:(NSString *)text;
- (BOOL)addImage:(UIImage *)image;
- (BOOL)removeAllImages;
- (BOOL)addURL:(NSURL *)url;
- (BOOL)removeAllURLs;

@property(nonatomic, readonly) NSString *serviceType;
@property(nonatomic, copy) SLComposeViewControllerCompletionHandler completionHandler;

@end

#endif
