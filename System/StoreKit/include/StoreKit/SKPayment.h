#import <StoreKit/SKProduct.h>

@interface SKPayment : NSObject <NSCopying, NSMutableCopying>
+ (instancetype)paymentWithProduct:(SKProduct *)product;
@property(nonatomic, copy, readonly) NSString *productIdentifier;
@property(nonatomic, readonly) NSInteger quantity;
@property(nonatomic, copy, readonly) NSData *requestData;
@property(nonatomic, copy, readonly) NSString *applicationUsername;
@end

@interface SKMutablePayment : SKPayment
@end
