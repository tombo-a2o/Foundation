#import <Foundation/Foundation.h>

@interface SKProduct : NSObject

// Getting Product Attributes
@property(readonly) NSString *localizedDescription;
@property(readonly) NSString *localizedTitle;
@property(readonly) NSDecimalNumber *price;
@property(readonly) NSLocale *priceLocale;
@property(readonly) NSString *productIdentifier;

// Getting Downloadable Content Information
@property(readonly) BOOL downloadable;
@property(nonatomic, readonly) NSArray/*<NSNumber *>*/ *downloadContentLengths;
@property(nonatomic, readonly) NSString *downloadContentVersion;

@end
