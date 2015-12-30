#import <StoreKit/StoreKit.h>
#import "AFNetworking.h"

NSString * const SKReceiptPropertyIsExpired = @"expired";
NSString * const SKReceiptPropertyIsRevoked = @"revoked";
NSString * const SKReceiptPropertyIsVolumePurchase = @"vpp";

@implementation SKRequest

- (void)start
{
    // SKRequest is an abstract class.
    [self doesNotRecognizeSelector:_cmd];
}

- (void)cancel
{
    // SKRequest is an abstract class.
    [self doesNotRecognizeSelector:_cmd];
}

@end

@implementation SKProductsRequest {
    NSSet *_productIdentifiers;
    SKProductsResponse *_productsResponse;
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
    _productsResponse = [[SKProductsResponse alloc] init];

    // FIXME: implement generating SKProductsResponse.

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSDictionary *parameters = @{@"productIdentifiers": [[_productIdentifiers allObjects] mutableCopy]};
    // FIXME: change URL
    NSError *serializerError = nil;
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://www.titech.ac/tombo/products" parameters:parameters error:&serializerError];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);

            _productsResponse = responseObject;
            [self.delegate productsRequest:self didReceiveResponse:_productsResponse];
        }
    }];
    [dataTask resume];
}

// Cancels a previously started request.
- (void)cancel
{
    // FIXME: implement
    [self doesNotRecognizeSelector:_cmd];
}

@end

@implementation SKReceiptRefreshRequest

@dynamic delegate;

// Initialized a receipt refresh request with optional properties.
- (instancetype)initWithReceiptProperties:(NSDictionary/*<NSString *, id>*/ *)properties
{
    // FIXME: implement
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

// Sends the request to the Apple App Store.
- (void)start
{
    // FIXME: implement
    [self doesNotRecognizeSelector:_cmd];
}

// Cancels a previously started request.
- (void)cancel
{
    // FIXME: implement
    [self doesNotRecognizeSelector:_cmd];
}

@end
