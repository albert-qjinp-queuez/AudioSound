//
//  AppDelegate.m
//  audiosound
//
//  Created by qjinp on 6/7/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#import "AppDelegate.h"

#define SAMPLE_RATE (8192)
#define SAMPLE_SIZE (256)
#define BUF_SIZE    (16384)

/* This routine will be called by the PortAudio engine when audio is needed.
 It may called at interrupt level on some machines so don't do anything
 that could mess up the system like calling malloc() or free().
 */
int patestCallback( const void *inputBuffer, void *outputBuffer,
                   unsigned long framesPerBuffer,
                   const PaStreamCallbackTimeInfo* timeInfo,
                   PaStreamCallbackFlags statusFlags,
                   void *userData )
{
    /* Cast data passed through stream to our structure. */
    AppDelegate* app = (__bridge AppDelegate *)userData;
    float *in = (float*)inputBuffer;
    
    unsigned flag = FFTW_MEASURE;
    [app.vibView setNeedsDisplay:YES];
    [app.frView setNeedsDisplay:YES];
    app.lastPlayTime = timeInfo->inputBufferAdcTime;
    
    if (app.pinBuf != NULL && framesPerBuffer != app.size) {
        free(app.pinBuf);
        free(app.pFreq);
        
        app.pinBuf = NULL;
        app.pFreq = NULL;
        app.pWindowed = NULL;
    }
    if (app.pinBuf == NULL){
        app.pinBuf = malloc(sizeof(double)*BUF_SIZE);
        app.pFreq = malloc(sizeof(double)*BUF_SIZE);
        app.pWindowed = malloc(sizeof(double)*BUF_SIZE);

        app.size = framesPerBuffer;
        app.plan = fftw_plan_r2r_1d(BUF_SIZE, app.pWindowed, app.pFreq, FFTW_REDFT00 , flag);
        [app.vibView setBuffer:(app.pWindowed) size:BUF_SIZE];
        [app.frView setBuffer:app.pFreq size:BUF_SIZE rate:SAMPLE_RATE ];
    }
    
    long int n;
    for( n=0 ; n < BUF_SIZE/2; n++){
        //shifting the data from the past to bothside
        app.pinBuf[n] = app.pinBuf[n+framesPerBuffer];
        app.pinBuf[BUF_SIZE-n-1] = app.pinBuf[BUF_SIZE-n-framesPerBuffer-1];
    }
    //new signal generated from the middle :)
    for (n=0; n<framesPerBuffer; n++) {
        app.pinBuf[BUF_SIZE/2+framesPerBuffer-n-1] = (double)in[n];
        app.pinBuf[BUF_SIZE/2-framesPerBuffer+n+1] = (double)in[n];
    }
    
    
    for (n=0; n<BUF_SIZE; n++) {
        app.pWindowed[n] = app.pinBuf[n];
        app.pWindowed[n] *= 0.5*(1-cos( 2*M_PI*n/(BUF_SIZE-1)) ); // Hann windowing
        app.pWindowed[n] *= exp(-0.007*fabs(n-(BUF_SIZE-1)/2));//poisson window
    }
    //my own transform
    double cossum = 0, sinsum = 0, absolute;
    for ( n=0; n < SAMPLE_SIZE*4; n++) {
        double fx = app.pWindowed[BUF_SIZE/2+n];
        double sinenwt = sin(880*M_PI/8192*n);
        double cosinenwt = cos(880*M_PI/8192*n);
        sinsum += fx*sinenwt;
        cossum += fx*cosinenwt;
    }
    absolute = sqrt(sinsum*sinsum + cossum*cossum);
    
    fftw_execute(app.plan);
    app.prvTime = timeInfo->inputBufferAdcTime;
    return 0;
}

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    _err = Pa_Initialize();
//    if( err != paNoError ) goto error;

    _pSelf = CFBridgingRetain(self);
    /* Open an audio I/O stream. */
    _err = Pa_OpenDefaultStream( &_stream,
                               1,          /* no input channels */
                               0,          /* stereo output */
                               paFloat32,  /* 32 bit floating point output */
                               SAMPLE_RATE,
                               SAMPLE_SIZE,        /* frames per buffer, i.e. the number
                                            of sample frames that PortAudio will
                                            request from the callback. Many apps
                                            may want to use
                                            paFramesPerBufferUnspecified, which
                                            tells PortAudio to pick the best,
                                            possibly changing, buffer size.*/
                               patestCallback, /* this is your callback function */
                               (void*)_pSelf ); /*This is a pointer that will be passed to
                                         your callback*/
//if( err != paNoError ) goto error;
    
    _err = Pa_StartStream( _stream );

    
    /* Sleep for several seconds. */
    //    Pa_Sleep(15*1000);
    

}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    fftw_destroy_plan(_plan);
    free(_pinBuf);
    free(_pWindowed);
    free(_pFreq);
    CFBridgingRelease(_pSelf);
    _err = Pa_StopStream( _stream );
    
    _err = Pa_Terminate();
}

@end
