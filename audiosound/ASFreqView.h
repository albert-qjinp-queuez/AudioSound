//
//  ASFreqView.h
//  audiosound
//
//  Created by qjinp on 6/20/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ASScratchView.h"

struct codeChart {
    double size;
    int count;
};

@interface ASFreqView : NSView

@property (assign) double *pBuf;
@property (assign) double *pCopy;
@property (assign) struct codeChart *pOct;
@property (assign) long int size;
@property (assign) long int rate;

@property (assign) int A1;
@property (assign) int A6;
@property (assign) double fqA1Lb;
@property (assign) double fqA6Lb;

@property (assign) IBOutlet NSTextField* maxFreqLabel;
@property (assign) IBOutlet NSSlider* noise;
@property (assign) IBOutlet ASScratchView* scaleView;


-(void)setBuffer:(double*)inbuf size:(long int)size rate:(long int)rate;
- (double)order2freq:(int)num;
- (int)freq2order:(double)freq;

@end
