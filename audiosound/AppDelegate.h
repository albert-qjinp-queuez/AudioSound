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
@property (assign) void *pSelf;
@property (assign) double *pBuf;
@property (assign) long int size;

@property (assign) double *outData;

@property (assign) fftw_plan plan;

@end
