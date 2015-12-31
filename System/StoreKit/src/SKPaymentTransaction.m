#import <StoreKit/StoreKit.h>

@implementation SKPaymentTransaction

- (instancetype)initWithTransactionIdentifier:(NSString *)transactionIdentifier payment:(SKPayment *)payment transactionState:(SKPaymentTransactionState)transactionState transactionReceipt:(NSData *)transactionReceipt transactionDate:(NSDate *)transactionDate error:(NSError *)error
{
    _transactionIdentifier = transactionIdentifier;
    _payment = payment;
    _transactionState = transactionState;
    _transactionReceipt = transactionReceipt;
    _transactionDate = transactionDate;
    _error = error;

    return self;
}

@end