#import <XCTest/XCTest.h>
#import "Nocilla.h"
#import "StoreKit.h"
#import "TestTransactionObserver.h"

@interface SKProductsRequestTests : XCTestCase <SKProductsRequestDelegate>
{
    XCTestExpectation *_expectation;
    SKRequest *_request;
    SKProductsResponse *_response;
    NSError *_error;
}
@end

@interface SKReceiptRefreshRequestTests : XCTestCase
@end

@implementation SKProductsRequestTests

- (void)setUp
{
    [super setUp];
    [[LSNocilla sharedInstance] start];
}

- (void)tearDown
{
    [[LSNocilla sharedInstance] stop];
    [super tearDown];
}

- (void)testStart {
    _expectation = [self expectationWithDescription:@"SKProductRequest start"];

    NSSet *set = [NSSet setWithObjects:@[@"productIdentifier1", @"productIdentifier2"], nil];
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    productsRequest.delegate = self;

    stubRequest(@"GET", @"http://www.google.com/nonsense/path").
    withHeaders(@{@"Accept": @"application/json"}).
    withBody(@"test body");

    [productsRequest start];

    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if (error != nil) {
            XCTFail(@"Timeout: %@", error);
            return;
        }
    }];
}

#pragma mark - SKProductsRequestDelegate

- (void)requestDidFinish:(SKRequest *)request
{
    _request = request;
    [_expectation fulfill];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    _request = request;
    _error = error;
    [_expectation fulfill];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    _request = request;
    _response = response;
    [_expectation fulfill];
}

@end

@implementation SKReceiptRefreshRequestTests
// FIXME: implement
@end