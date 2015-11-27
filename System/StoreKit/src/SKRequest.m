#import <StoreKit/StoreKit.h>

NSString * const SKReceiptPropertyIsExpired = @"expired";
NSString * const SKReceiptPropertyIsRevoked = @"revoked";
NSString * const SKReceiptPropertyIsVolumePurchase = @"vpp";

@implementation SKRequest

// Sends the request to the Apple App Store.
- (void)start
{
    // FIXME: implement
}

// Cancels a previously started request.
- (void)cancel
{
    // FIXME: implement
}

@end

@implementation SKProductsRequest

// Initializes the request with the set of product identifiers.
- (instancetype)initWithProductIdentifiers:(NSSet *)productIdentifiers
{
    // FIXME: implement
    return nil;
}

@end

@implementation SKReceiptRefreshRequest

// Initialized a receipt refresh request with optional properties.
- (instancetype)initWithReceiptProperties:(NSDictionary/*<NSString *, id>*/ *)properties
{
    // FIXME: implement
    return nil;
}

@end
