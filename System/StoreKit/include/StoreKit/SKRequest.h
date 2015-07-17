#ifndef STOREKIT_SKRequest
#define STOREKIT_SKRequest

#import <Foundation/NSError.h>
#import <Foundation/NSSet.h>

@class SKRequest;

@protocol SKRequestDelegate
- (void)requestDidFinish:(SKRequest *)request;
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error;
@end

@interface SKRequest : NSObject
- (void)start;
- (void)cancel;
@property(nonatomic, assign) id< SKRequestDelegate > delegate;
@end

@class SKProductsRequest;
@class SKProductsResponse;

@protocol SKProductsRequestDelegate <SKRequestDelegate>
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response;
@end

@interface SKProductsRequest : SKRequest
- (instancetype)initWithProductIdentifiers:(NSSet *)productIdentifiers;
@property(nonatomic, assign) id< SKProductsRequestDelegate > delegate;
@end

#endif
