//
//  AppDelegate.h
//  audiosound
//
//  Created by qjinp on 6/7/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "portaudio.h"
#import "pa_mac_core.h"
#include "fftw3.h"
#import "Music.h"
 
#import "ASVibrationView.h"
#import "ASFreqView.h"
#import "ASScratchView.h"
typedef struct
{
    float left_phase;
    float right_phase;
}
paTestData;

int patestCallback( const void *inputBuffer, void *outputBuffer,
                   unsigned long framesPerBuffer,
                   const PaStreamCallbackTimeInfo* timeInfo,
                   PaStreamCallbackFlags statusFlags,
                   void *userData );


@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet ASVibrationView* vibView;
@property (assign) IBOutlet ASFreqView* frView;
@property (assign) IBOutlet ASScratchView* scratchView;

@property (assign) PaError err;
@property (assign) PaStream *stream;
@property (assign) CFTypeRef pSelf;
@property (assign) long int size;
@property (assign) double noiseLv;
@property (assign) double prvTime;

@property (assign) double *pinBuf;
//@property (assign) double *pWindowed;
@property (assign) double *pFreq;
@property (assign,readwrite) double lastPlayTime;

//@property (assign) fftw_plan plan;
-(void)CFT;
-(double)getPowerOfOrder:(int)order;
-(void)get3PowerOfCodeNo:(int)code;
@end
