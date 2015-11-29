#import <StoreKit/StoreKit.h>

@implementation SKProductsResponse

- (instancetype)init {
    _products = [[NSMutableArray alloc] init];
    return self;
}

@end
