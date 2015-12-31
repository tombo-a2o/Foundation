#import <XCTest/XCTest.h>
#import "StoreKit.h"
#import "TestTransactionObserver.h"

@interface SKPaymentQueueTests : XCTestCase

@end

@implementation SKPaymentQueueTests {
    XCTestExpectation *_expectation;
}

- (void)testCanMakePayments {
    // Now canMakePayments always returns YES
    XCTAssertTrue([SKPaymentQueue canMakePayments]);
}

- (void)testDefaultQueue {
    SKPaymentQueue *queue1 = [SKPaymentQueue defaultQueue];
    XCTAssertNotNil(queue1);
    SKPaymentQueue *queue2 = [SKPaymentQueue defaultQueue];
    XCTAssertEqualObjects(queue1, queue2);
}

- (void)testAddAndRemoveTransactionObserver {
    SKPaymentQueue *queue = [SKPaymentQueue defaultQueue];

    TestTransactionObserver *observer1 = [[TestTransactionObserver alloc] init];
    TestTransactionObserver *observer2 = [[TestTransactionObserver alloc] init];

    [queue addTransactionObserver:observer1];
    [queue addTransactionObserver:observer2];

    [queue removeTransactionObserver:observer1];
    [queue removeTransactionObserver:observer2];
}

- (void)testAddPayment {
    SKPaymentQueue *queue = [SKPaymentQueue defaultQueue];
    TestTransactionObserver *observer = [[TestTransactionObserver alloc] init];
    [queue addTransactionObserver:observer];

    SKProduct *product = [[SKProduct alloc] initWithProductIdentifier:@"product1" localizedTitle:@"title" localizedDescription:@"desc" price:[[NSDecimalNumber alloc] initWithInt:101] priceLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    SKPayment *payment = [SKPayment paymentWithProduct:product];

    _expectation = [self expectationWithDescription:@"SKPaymentTransactionObserver"];

    [queue addPayment:payment];

    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if (error != nil) {
            XCTFail(@"Timeout: %@", error);
            return;
        }
    }];
}

@end