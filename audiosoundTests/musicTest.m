//
//  musicTest.m
//  audiosound
//
//  Created by qjinp on 7/11/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Music.h"
@interface musicTest : XCTestCase

@end

@implementation musicTest

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
    XCTAssertEqualWithAccuracy(getScale(freq2CodeNo(440.0)), 0, 0.01, @"aAcc!");
}

- (void)testA
{
    XCTAssertEqual(getScale(freq2CodeNo(440.0)), 0, @"a!");
    
    XCTAssertTrue((getScale(freq2CodeNo(440.0)) == 0), @"a!");
}
- (void)testBm
{
    XCTAssertEqual(getScale(freq2CodeNo(463.0)), 1, @"bm!");
}
- (void)testB
{
    XCTAssertEqual(getScale(freq2CodeNo(496.0)), 2, @"b!");
}
- (void)testAm
{
    XCTAssertEqual(getScale(freq2CodeNo(420.0)), 11, @"Am!");
}
- (void)testG
{
    XCTAssertEqual(getScale(freq2CodeNo(390.0)), 10, @"G!");
}
- (void)testgetCodeNo
{
    int a = freq2CodeNo(440.0);
    XCTAssertEqual(a, 0, @"G!%d", a);
}
- (void)testgetCodeNo2
{
    int a = freq2CodeNo(110.0);
    XCTAssertEqual(a, -24, @"G!%d", a);
}
- (void)testgetFreq
{
    double a = CodeNo2FreqRound(0);
    XCTAssertEqualWithAccuracy(a, 440.0, 0.01, @"Freq%f", a);
    a = CodeNo2FreqRound(-1);
    XCTAssertEqualWithAccuracy(a, 415.3, 0.01, @"Freq%f", a);
    a = CodeNo2FreqRound(-2);
    XCTAssertEqualWithAccuracy(a, 392.0, 1, @"Freq%f", a);

}
- (void)testgetFreqBm
{
    double a = CodeNo2FreqRound(1);
    XCTAssertEqualWithAccuracy(a, 466.0, 0.2, @"Freq%f", a);
}
- (void)testgetFreqLA
{
    double a = CodeNo2FreqRound(-12);
    XCTAssertEqualWithAccuracy(a, 220, 0.002, @"Freq%f", a);
}
- (void)testgetFreqLLA
{
    double a = CodeNo2FreqRound(-24);
    XCTAssertEqualWithAccuracy(a, 110, 0.002, @"Freq%f", a);
}
- (void)testgetFreqFL
{
    XCTAssertEqualWithAccuracy(  CodeNo2FreqFloor( 0) , 427, 1, @"Freq");
    XCTAssertEqualWithAccuracy(  CodeNo2FreqCeil( -1) , 427, 1, @"Freq");
}

@end