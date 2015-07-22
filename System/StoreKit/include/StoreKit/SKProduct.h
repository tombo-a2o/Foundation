#import <Foundation/NSObject.h>
#import <Foundation/NSLocale.h>
#import <Foundation/NSDecimalNumber.h>
#import <Foundation/NSString.h>

@interface SKProduct : NSObject
@property(readonly) NSString *localizedDescription;
@property(readonly) NSString *localizedTitle;
@property(readonly) NSDecimalNumber *price;
@property(readonly) NSLocale *priceLocale;
@property(readonly) NSString *productIdentifier;
@property(readonly) BOOL downloadable;
@end
