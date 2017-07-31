#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>

@interface SampleTests : XCTestCase
@end

@implementation SampleTests

- (void)setUp
{
    [super setUp];
    NSLog(@"%s", __FUNCTION__);
}

- (void)tearDown
{
    NSLog(@"%s", __FUNCTION__);
    [super tearDown];
}

- (void)testStart {
    XCTAssertEqual(@"hogehoge", @"hogehoge");
}

@end
