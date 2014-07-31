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
    initMusic();
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
    double a = codeNo2FreqRound(0);
    XCTAssertEqualWithAccuracy(a, 440.0, 0.01, @"Freq%f", a);
    a = codeNo2FreqRound(-1);
    XCTAssertEqualWithAccuracy(a, 415.3, 0.01, @"Freq%f", a);
    a = codeNo2FreqRound(-2);
    XCTAssertEqualWithAccuracy(a, 392.0, 1, @"Freq%f", a);

}
- (void)testgetFreqBm
{
    double a = codeNo2FreqRound(1);
    XCTAssertEqualWithAccuracy(a, 466.0, 0.2, @"Freq%f", a);
}
- (void)testgetFreqLA
{
    double a = codeNo2FreqRound(-12);
    XCTAssertEqualWithAccuracy(a, 220, 0.002, @"Freq%f", a);
}
- (void)testgetFreqLLA
{
    double a = codeNo2FreqRound(-24);
    XCTAssertEqualWithAccuracy(a, 110, 0.002, @"Freq%f", a);
}
- (void)testgetFreqFL
{
    XCTAssertEqualWithAccuracy(  codeNo2FreqFloor( 0) , 427, 1, @"Freq");
    XCTAssertEqualWithAccuracy(  codeNo2FreqCeil( -1) , 427, 1, @"Freq");
}
- (void)testCodeBound
{
    int firstCode = freq2CodeNo(55.0);
    int lastCode = order2CodeNo((int)BUF_SIZE);
    XCTAssertEqual( firstCode , -36, @"code %d", firstCode);
    XCTAssertEqual( lastCode , 39, @"code %d", lastCode);
}
-(void)testOrder2s
{
    double LFreq = order2freq(1);
    double dur = (double)SAMPLE_RATE/(double)BUF_SIZE/2;
    XCTAssertEqual( LFreq , dur, @"code %f %f", LFreq, dur);
    
    //this has to be false when default values changes
    XCTAssertEqual( freq2order(440.0) , 3520, @"code %f %f", LFreq, dur);
    
}

@end
