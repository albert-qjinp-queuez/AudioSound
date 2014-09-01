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

@property (assign) double *pBuf;
@property (assign) double *pCopy;
@property (assign) struct codePower *pCode;
@property (assign) long int size;
@property (assign) long int rate;

@property (assign) int LastCode;

@property (assign) IBOutlet NSTextField* maxFreqLabel;
@property (assign) IBOutlet ASScratchView* scaleView;


-(void)setBuffer:(double*)inbuf size:(long int)size rate:(long int)rate;

@end
