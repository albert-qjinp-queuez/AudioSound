//
//  TestASFreqView.m
//  audiosound
//
//  Created by qjinp on 7/12/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ASFreqView.h"
#import "Music.h"

@interface TestASFreqView : XCTestCase

@end

#define SAMPLE_RATE (8192)
#define SAMPLE_SIZE (256)
#define BUF_SIZE    (16384)
double * pFreq;
@implementation TestASFreqView
ASFreqView * fqView;
- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    fqView = [[ASFreqView alloc]initWithFrame: (NSRect){0,0,10,10} ];
    pFreq = malloc(sizeof(double)*BUF_SIZE);
    
    [fqView setBuffer:pFreq size:BUF_SIZE rate:SAMPLE_RATE ];
}

- (void)tearDown
{
    free(pFreq);
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTAssertTrue(true ,@"%d",[fqView freq2order:fqView.fqA1Lb]);
    XCTAssertTrue(true ,@"%d",[fqView freq2order:fqView.fqA6Lb]);
    
    
}
- (void)testLoop{
    BOOL run = false;
    for (int i = [fqView freq2order:fqView.fqA1Lb]; i < [fqView freq2order:fqView.fqA6Lb]; i++) {
        run = true;
        XCTAssertTrue( 0 < i, @"outBound %d", i);
        
        int codeNo = freq2CodeNo([fqView order2freq:i]);
        XCTAssertTrue( 0 <= codeNo- fqView.A1 , @"outBound %d %d %d", codeNo, codeNo- fqView.A1, i);
        XCTAssertTrue( codeNo- fqView.A1 < fqView.A6 -fqView.A1, @"outBound %d %d %d", i, codeNo, fqView.A6);
        fqView.pCode[codeNo - fqView.A1].size += fqView.pCode[i].size;
    }
    XCTAssertTrue(run);
}

@end
