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
#define BUF_SIZE    (40496)

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
    
    if (app.pBuf != NULL && framesPerBuffer != app.size) {
        free(app.pBuf);
        free(app.pFreq);
        
        app.pBuf = NULL;
        app.pFreq = NULL;
    }
    if (app.pBuf == NULL){
        app.pBuf = malloc(sizeof(double)*BUF_SIZE);
        app.pFreq = malloc(sizeof(double)*BUF_SIZE);

        app.size = framesPerBuffer;
        app.plan = fftw_plan_r2r_1d(BUF_SIZE, app.pBuf, app.pFreq, FFTW_REDFT00 , flag);
        [app.vibView setBuffer:app.pBuf size:framesPerBuffer];
        [app.frView setBuffer:app.pFreq size:BUF_SIZE rate:SAMPLE_RATE];

    }
    
    int i;
    for (i=0; i<framesPerBuffer; i++) {
        app.pBuf[i] = (double)in[i];
    }
    for( i=framesPerBuffer ; i<BUF_SIZE; i++){
        //zero padding
        app.pBuf[i] = 0.0;
    }
    fftw_execute(app.plan);
    
    double max=0;
    float sum=0;
    int maxInex = 0;
    app.pFreq[0] = fabs(app.pFreq[0]);
    app.pFreq[BUF_SIZE-1] = fabs(app.pFreq[BUF_SIZE-1]);
    for (int i = 1; i < BUF_SIZE; i++) {
        app.pFreq[i] = fabs(app.pFreq[i]);
        app.pFreq[BUF_SIZE-i-1] = fabs(app.pFreq[BUF_SIZE-i-1]);
        if(app.pFreq[i] > app.pFreq[i-1]){
            app.pFreq[i-1] = 0;
        }
        if(app.pFreq[BUF_SIZE-i] < app.pFreq[BUF_SIZE-i-1]){
            app.pFreq[BUF_SIZE-i] = 0;
        }
        
        if( max < app.pFreq[i]){
            max = app.pFreq[i];
            maxInex = i;
        }
        sum+=app.pFreq[i];
    }
    if (BUF_SIZE != 0) sum = sum/BUF_SIZE;
    
    if (max == 0) max = 1;
    
    
    for (int i = 1; i < BUF_SIZE; i++) {
        if (app.pFreq[i] > 0.001) {
            [app.scratchView add:app.pFreq[i] on:i at:timeInfo->inputBufferAdcTime];
        }
        app.pFreq[i] = app.pFreq[i]/max;
    }
    
    app.text.doubleValue = ((double)maxInex)/BUF_SIZE *SAMPLE_RATE /2.0;
    
    [app.vibView setNeedsDisplay:YES];
    [app.frView setNeedsDisplay:YES];
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
                               _pSelf ); /*This is a pointer that will be passed to
                                         your callback*/
//if( err != paNoError ) goto error;
    
    _err = Pa_StartStream( _stream );

    
    /* Sleep for several seconds. */
    //    Pa_Sleep(15*1000);
    

}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    fftw_destroy_plan(_plan);
    free(_pBuf);
    free(_pFreq);
    CFBridgingRelease(_pSelf);
    _err = Pa_StopStream( _stream );
    
    _err = Pa_Terminate();
}
@end
