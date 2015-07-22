#import <Foundation/NSObject.h>
#import <Foundation/NSArray.h>

@interface SKProductsResponse : NSObject
@property(readonly) NSArray *products;
@property(readonly) NSArray *invalidProductIdentifiers;
@end
