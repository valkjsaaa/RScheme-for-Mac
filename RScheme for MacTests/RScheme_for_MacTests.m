//
//  RScheme_for_MacTests.m
//  RScheme for MacTests
//
//  Created by Jackie Yang on 11/1/14.
//  Copyright (c) 2014 Jackie Yang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "RSchemeParser.h"

@interface RScheme_for_MacTests : XCTestCase

@end

@implementation RScheme_for_MacTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    // This is an example of a functional test case.
    NSMutableString* output = [NSMutableString new];
    RSchemeParser* parser = [[RSchemeParser alloc] initWithFileHandle:output];
    [parser parse:@"(+ 1 2)" error:nil];
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample
{
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
