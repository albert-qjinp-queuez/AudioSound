//
//  ASFreqView.h
//  audiosound
//
//  Created by qjinp on 6/20/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ASScratchView.h"
#include "fftw3.h"


@interface ASFreqView : NSView

@property (assign) fftw_complex *pBuf;
@property (assign) double *pCopy;
@property (assign) struct codePower *pCode;
@property (assign) long int size;
@property (assign) long int rate;

@property (assign) int A1;
//@property (assign) int A6;
@property (assign) int LastCode;
@property (assign) double fqA1Lb;
@property (assign) double fqA6Lb;

@property (assign) IBOutlet NSTextField* maxFreqLabel;
@property (assign) IBOutlet NSSlider* noise;
@property (assign) IBOutlet ASScratchView* scaleView;


-(void)setBuffer:(fftw_complex*)inbuf size:(long int)size rate:(long int)rate;

@end
