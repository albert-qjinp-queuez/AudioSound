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

@implementation TestASFreqView
ASFreqView * fqView;
- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    fqView = [[ASFreqView alloc]initWithFrame: (NSRect){0,0,10,10} ];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    
    XCTAssertFalse( sizeof(fqView.pOct) == sizeof(double)*fqView.A6 -fqView.A1
                  , @"outBound %d % d", fqView.A6 , fqView.A1);
    for (int i = [fqView freq2order:fqView.fqA1Lb]; i < [fqView freq2order:fqView.fqA6Lb]; i++) {
        XCTAssertFalse( fqView.A6 -fqView.A1 < i, @"outBound");
        
        int codeNo = freq2CodeNo([fqView order2freq:i]);
        fqView.pOct[codeNo - fqView.A1] += fqView.pOct[i];
    }
}

@end
