#import <StoreKit/SKProduct.h>

@interface SKPayment : NSObject <NSCopying, NSMutableCopying>
+ (instancetype)paymentWithProduct:(SKProduct *)product;
@end

@interface SKMutablePayment : SKPayment
@end
