#import <StoreKit/SKPaymentQueue.h>
#import "AFNetworking.h"

NSString * const SKTomboPaymentsURL = @"http://tombo.titech.ac/payments";

static SKPaymentQueue* _defaultQueue;

@implementation SKPaymentQueue {
    NSMutableArray *_transactionObservers;
    AFURLSessionManager *_URLSessionManager;
}

- (instancetype)init {
    _transactionObservers = [[NSMutableArray alloc] init];
    return [super init];
}

// Returns whether the user is allowed to make payments.
+ (BOOL)canMakePayments
{
    // TODO: implement parental controls etc.
    return YES;
}

// Returns the singleton payment queue instance.
+ (instancetype)defaultQueue
{
    if (!_defaultQueue) {
        _defaultQueue = [[SKPaymentQueue alloc] init];
    }
    return _defaultQueue;
}

// Adds an observer to the payment queue.
- (void)addTransactionObserver:(id<SKPaymentTransactionObserver>)observer
{
    [_transactionObservers addObject:observer];
}

// Removes an observer from the payment queue.
- (void)removeTransactionObserver:(id<SKPaymentTransactionObserver>)observer
{
    [_transactionObservers removeObject:observer];
}

// Adds a payment request to the queue.
- (void)addPayment:(SKPayment *)payment
{
    // TODO: Support a "real" queue. Now we don't use a queue. An added payment is immediately executed.

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _URLSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSObject *applicationUserName = payment.applicationUsername;
    if (applicationUserName == nil) {
        applicationUserName = [NSNull null];
    }

    NSDictionary *parameters = @{@"payments": @[@{
        @"productIdentifier": payment.productIdentifier,
        @"quantity": [NSNumber numberWithInteger:payment.quantity],
        @"requestData": [NSNull null],
        @"applicationUsername": applicationUserName
    }]};
    NSError *serializerError = nil;
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:SKTomboPaymentsURL parameters:parameters error:&serializerError];
    _URLSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];

    NSURLSessionDataTask *dataTask = [_URLSessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        _URLSessionManager = nil;

        NSMutableArray *transactions = [[NSMutableArray alloc] init];
        if (error) {
            NSLog(@"Error(%@): %@", NSStringFromClass([self class]), error);
            // FIXME: generate random transaction id in UUID-like format
            SKPaymentTransaction *transaction = [[SKPaymentTransaction alloc] initWithTransactionIdentifier:nil payment:payment transactionState:SKPaymentTransactionStateFailed transactionDate:nil error:error];
            [transactions addObject:transaction];
        } else {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSLocale *posixLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
            [dateFormatter setLocale:posixLocale];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];

            NSArray *transactionsArray = [responseObject objectForKey:@"transactions"];
            for (NSDictionary *transactionDict in transactionsArray) {
                NSString *transactionIdentifier = [transactionDict objectForKey:@"transactionIdentifier"];
                NSDate *transactionDate = [dateFormatter dateFromString:[transactionDict objectForKey:@"transactionDate"]];

                SKPaymentTransaction *transaction = [[SKPaymentTransaction alloc] initWithTransactionIdentifier:transactionIdentifier payment:payment transactionState:SKPaymentTransactionStatePurchased transactionDate:transactionDate error:error];
                [transactions addObject:transaction];
            }
        }
        for (id<SKPaymentTransactionObserver> observer in _transactionObservers) {
            [observer paymentQueue:self updatedTransactions:transactions];
        }
    }];

    [dataTask resume];
}

// Completes a pending transaction.
- (void)finishTransaction:(SKPaymentTransaction *)transaction
{
    // FIXME: implement
    [self doesNotRecognizeSelector:_cmd];
}

// Asks the payment queue to restore previously completed purchases.
- (void)restoreCompletedTransactions
{
    // FIXME: implement
    [self doesNotRecognizeSelector:_cmd];
}

// Asks the payment queue to restore previously completed purchases, providing an opaque identifier for the user’s account.
- (void)restoreCompletedTransactionsWithApplicationUsername:(NSString *)username
{
    // FIXME: implement
    [self doesNotRecognizeSelector:_cmd];
}

// Adds a set of downloads to the download list.
- (void)startDownloads:(NSArray *)downloads
{
    // FIXME: implement
    [self doesNotRecognizeSelector:_cmd];
}

// Removes a set of downloads from the download list.
- (void)cancelDownloads:(NSArray *)downloads
{
    // FIXME: implement
    [self doesNotRecognizeSelector:_cmd];
}

// Pauses a set of downloads.
- (void)pauseDownloads:(NSArray *)downloads
{
    // FIXME: implement
    [self doesNotRecognizeSelector:_cmd];
}

// Resumes a set of downloads.
- (void)resumeDownloads:(NSArray *)downloads
{
    // FIXME: implement
    [self doesNotRecognizeSelector:_cmd];
}

@end
