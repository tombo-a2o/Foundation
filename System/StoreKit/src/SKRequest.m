#import <StoreKit/StoreKit.h>

NSString * const SKReceiptPropertyIsExpired = @"expired";
NSString * const SKReceiptPropertyIsRevoked = @"revoked";
NSString * const SKReceiptPropertyIsVolumePurchase = @"vpp";

@implementation SKRequest

- (void)start
{
    [self doesNotRecognizeSelector:_cmd];
}

- (void)cancel
{
    [self doesNotRecognizeSelector:_cmd];
}

@end

@implementation SKProductsRequest {
    NSMutableArray *_productIdentifiers;
    SKProductsResponse *_response;
}

@dynamic delegate;

// Initializes the request with the set of product identifiers.
- (instancetype)initWithProductIdentifiers:(NSSet/*<NSString *>*/ *)productIdentifiers
{
    _productIdentifiers = [productIdentifiers mutableCopy];
    return [super init];
}


// Sends the request to the Apple App Store.
- (void)start
{
    _response = [[SKProductsResponse alloc] init];

    // FIXME: implement generating SKProductsResponse.

    [self.delegate productsRequest:self didReceiveResponse:_response];
}

// Cancels a previously started request.
- (void)cancel
{
    // FIXME: implement
}

@end

@implementation SKReceiptRefreshRequest

@dynamic delegate;

// Initialized a receipt refresh request with optional properties.
- (instancetype)initWithReceiptProperties:(NSDictionary/*<NSString *, id>*/ *)properties
{
    // FIXME: implement
    return nil;
}

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
