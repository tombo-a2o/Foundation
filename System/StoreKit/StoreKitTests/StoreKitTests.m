//
//  StoreKitTests.m
//  StoreKitTests
//
//  Created by Tasuku SUENAGA on 2015/12/16.
//  Copyright © 2015年 Tombo, inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StoreKit.h"

@interface StoreKitTests : XCTestCase

@end

@implementation StoreKitTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCanMakePayments {
    XCTAssertTrue([SKPaymentQueue canMakePayments]);
}

@end
