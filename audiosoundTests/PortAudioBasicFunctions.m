//
//  PortAudioBasicFunctions.m
//  audiosound
//
//  Created by qjinp on 6/10/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "../portaudio/include/portaudio.h"
#import "../portaudio/include/pa_mac_core.h"
#import "../audiosound/AppDelegate.h"


PaError err;
PaStream *stream;
paTestData data;
#define SAMPLE_RATE (44100)

@interface PortAudioBasicFunctions : XCTestCase

@end

@implementation PortAudioBasicFunctions

- (void)setUp
{
    
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    err = Pa_Initialize();
    if( err != paNoError )
        XCTFail(@"No implementation for \"%d\"", err);
    
    
    /* Open an audio I/O stream. */
    err = Pa_OpenDefaultStream( &stream,
                               0,          /* no input channels */
                               2,          /* stereo output */
                               paFloat32,  /* 32 bit floating point output */
                               SAMPLE_RATE,
                               256,        /* frames per buffer, i.e. the number
                                            of sample frames that PortAudio will
                                            request from the callback. Many apps
                                            may want to use
                                            paFramesPerBufferUnspecified, which
                                            tells PortAudio to pick the best,
                                            possibly changing, buffer size.*/
                               patestCallback, /* this is your callback function */
                               &data ); /*This is a pointer that will be passed to
                                         your callback*/
    if( err != paNoError)
        XCTFail(@"No implementation for \"%d\"", err);
}

- (void)tearDown
{
    err = Pa_CloseStream( stream );
    if( err != paNoError )
        XCTFail(@"No implementation for \"%d\"", err);
    
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    err = Pa_Terminate();
    if( err != paNoError )
        XCTFail(@"No implementation for \"%d\"", err);
    [super tearDown];
}

- (void)testExample
{
    err = Pa_StartStream( stream );
    if( err != paNoError )
      XCTFail(@"No implementation for \"%d\"", err);
    
    /* Sleep for several seconds. */
//    Pa_Sleep(15*1000);
    
    err = Pa_StopStream( stream );
    if( err != paNoError )
        XCTFail(@"No implementation for \"%d\"", err);
    
}

@end
