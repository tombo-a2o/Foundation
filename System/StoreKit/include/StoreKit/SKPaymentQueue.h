#import <Foundation/NSObject.h>
#import <StoreKit/SKPayment.h>
#import <StoreKit/SKPaymentTransaction.h>

@protocol SKPaymentTransactionObserver
@end

@interface SKPaymentQueue : NSObject
+ (BOOL)canMakePayments;
+ (instancetype)defaultQueue;
- (void)addTransactionObserver:(id<SKPaymentTransactionObserver>)observer;
- (void)removeTransactionObserver:(id<SKPaymentTransactionObserver>)observer;
- (void)addPayment:(SKPayment *)payment;
- (void)finishTransaction:(SKPaymentTransaction *)transaction;
- (void)restoreCompletedTransactions;
- (void)restoreCompletedTransactionsWithApplicationUsername:(NSString *)username;
- (void)startDownloads:(NSArray *)downloads;
- (void)cancelDownloads:(NSArray *)downloads;
- (void)pauseDownloads:(NSArray *)downloads;
- (void)resumeDownloads:(NSArray *)downloads;

@property(nonatomic, readonly) NSArray *transactions;
@end
