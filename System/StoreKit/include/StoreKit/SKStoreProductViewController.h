#import <UIKit/UIViewController.h>

extern NSString * const SKStoreProductParameterITunesItemIdentifier;
extern NSString * const SKStoreProductParameterAffiliateToken;
extern NSString * const SKStoreProductParameterCampaignToken;
extern NSString * const SKStoreProductParameterProviderToken;

@protocol SKStoreProductViewControllerDelegate
@end

@interface SKStoreProductViewController : UIViewController
- (void)loadProductWithParameters:(NSDictionary*)parameters
                  completionBlock:(void (^)(BOOL result, NSError *error))block;
@property(nonatomic, assign) id< SKStoreProductViewControllerDelegate > delegate;
@end
