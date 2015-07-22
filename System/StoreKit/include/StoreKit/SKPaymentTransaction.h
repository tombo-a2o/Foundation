#import <Foundation/NSObject.h>
#import <Foundation/NSData.h>
#import <Foundation/NSDate.h>

enum {
    SKPaymentTransactionStatePurchasing,
    SKPaymentTransactionStatePurchased,
    SKPaymentTransactionStateFailed,
    SKPaymentTransactionStateRestored,
    SKPaymentTransactionStateDeferred,
};
typedef NSInteger SKPaymentTransactionState;

@interface SKPaymentTransaction : NSObject
@property(nonatomic, readonly) NSError *error;
@property(nonatomic, readonly) SKPayment *payment;
@property(nonatomic, readonly) SKPaymentTransactionState transactionState;
@property(nonatomic, readonly) NSString *transactionIdentifier;
@property(nonatomic, readonly) NSData *transactionReceipt;
@property(nonatomic, readonly) NSDate *transactionDate;
@property(nonatomic, readonly) NSArray *downloads;
@property(nonatomic, readonly) SKPaymentTransaction *originalTransaction;
@end
