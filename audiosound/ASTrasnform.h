//
//  ASTrasnform.h
//  audiosound
//
//  Created by qjinp on 8/20/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Music.h"
#import "ASFreqView.h"
#import "AppDelegate.h"
@class AppDelegate;

@interface ASTrasnform : NSThread

@property (assign) double *pInBuf;
@property (assign) double *pFreq;
@property (assign) int freqSize;
@property (assign) int inputSize;
@property (assign) BOOL running;

@property (retain) ASFreqView* frView;
@property (retain) AppDelegate* app;

-(void)setInputSize:(int)inbufSize frqBufSize:(int)frqsize;
-(void)setApp:(AppDelegate *)appD freqView:(ASFreqView*)frV;
-(void)startCalc;


-(void)get3PowerOfCodeNo:(int)code;
@end
