#import "TestTransactionObserver.h"

@implementation TestTransactionObserver

// Handing Transactions
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray/*<SKPaymentTransaction *>*/ *)transactions
{
    // FIXME: implement
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray/*<SKPaymentTransaction *>*/ *)transactions
{
    // FIXME: implement
}

// Handling Restored Transactions
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    // FIXME: implement
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    // FIXME: implement
}

// Handling Download Actions
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray/*<SKDownload *>*/ *)downloads
{
    // FIXME: implement
}

@end