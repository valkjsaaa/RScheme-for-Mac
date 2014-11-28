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
#import "y.tab.h"
#import "MessageBlocks.h"

@interface RScheme_for_MacTests : XCTestCase

@property NSMutableString* output;

@property RSchemeParser* parser;

@end

@implementation RScheme_for_MacTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _output = [NSMutableString new];
    _parser = [[RSchemeParser alloc] initWithFileHandle:_output];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testArithmetic
{
    [_output setString:@""];
    [_parser parse:@"(+ 1 2)" error:nil];
    XCTAssert([_output isEqualToString:@"3"], @"Passed");
    [_output setString:@""];
    [_parser parse:@"(+ 10.0 2)" error:nil];
    XCTAssert([_output isEqualToString:@"12.000000"], @"Passed");
    [_output setString:@""];
    [_parser parse:@"(+ 1 2.0)" error:nil];
    XCTAssert([_output isEqualToString:@"3.000000"], @"Passed");
    [_output setString:@""];
    [_parser parse:@"(- 1 2)" error:nil];
    XCTAssert([_output isEqualToString:@"-1"], @"Passed");
    [_output setString:@""];
    [_parser parse:@"(> 1 2)" error:nil];
    XCTAssert([_output isEqualToString:@"f"], @"Passed");
    [_output setString:@""];
    [_parser parse:@"(< 1 2)" error:nil];
    XCTAssert([_output isEqualToString:@"t"], @"Passed");
    [_output setString:@""];
    [_parser parse:@"(> 1.0 2)" error:nil];
    XCTAssert([_output isEqualToString:@"f"], @"Passed");
    [_output setString:@""];
    [_parser parse:@"(/ 1 2)" error:nil];
    XCTAssert([_output isEqualToString:@"0"], @"Passed");
    [_output setString:@""];
    [_parser parse:@"(/ 1.0 2)" error:nil];
    XCTAssert([_output isEqualToString:@"0.500000"], @"Passed");
    [_output setString:@""];
    [_parser parse:@"(% 3 2)" error:nil];
    XCTAssert([_output isEqualToString:@"1"], @"Passed");
}

- (void)testExample
{
    [_output setString:@""];
    [_parser parse:@"(define (abs x) (if (> x 0) x (- 0 x)))" error:nil];
    [_parser parse:@"(define (square x) (* x x))" error:nil];
    [_parser parse:@"(define (cube x) (* x x x))" error:nil];
    [_parser parse:@"(define (cube_root x) (cube_root_iter 1.0 x))" error:nil];
    [_parser parse:@"(define (cube_root_iter guess x) (if (good-enough? guess x) guess  (cube_root_iter (improve guess x) x)))" error:nil];
    [_parser parse:@"(define (good-enough? guess x) (< (abs (- (cube guess) x)) 0.001))" error:nil];
    [_parser parse:@"(define (improve guess x) (/ (+ (/ x (square guess)) (* 2 guess)) 3))" error:nil];
    [_parser parse:@"(write (cube_root 27))" error:nil];
    XCTAssert([_output isEqualToString:@"okokokokokokok3.000001ok"], @"Pass");
}

- (void)testGUI
{
    _output = [NSMutableString new];
    _parser = [[RSchemeParser alloc] initWithFileHandle:_output];
    //[_parser parse:@"\n" error:nil];
    [_output setString:@""];
    [_parser parseMultiline:@"\n" error:nil];
    XCTAssert([_output isEqualToString:@""], @"Passed");
    [_output setString:@""];
    [_parser parseMultiline:@"(+ 1 2)\n(+ 3 4)" error:nil];
    XCTAssert([_output isEqualToString:@"37"], @"Passed");
    [_output setString:@""];
    [_parser parseMultiline:@"(+ 1 \n2)" error:nil];
    XCTAssert([_output isEqualToString:@"3"], @"Passed");
}

- (void)testYyParser
{
    YY_BUFFER_STATE buf;
    
    buf = yy_scan_string("(+ 1 2)");
    
    yyparse();
    
    yy_delete_buffer(buf);
}

- (void)testPerformanceExample
{
    // This is an example of a performance test case.
    [self measureBlock:^{
        [self testExample];
        [self testArithmetic];
        // Put the code you want to measure the time of here.
    }];
}

@end
