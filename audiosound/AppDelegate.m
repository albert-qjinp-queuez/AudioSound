//
//  AppDelegate.m
//  audiosound
//
//  Created by qjinp on 6/7/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#import "AppDelegate.h"


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
        app.pFreq = malloc(sizeof(fftw_complex)*BUF_SIZE);
        app.pWindowed = malloc(sizeof(double)*BUF_SIZE);

        app.size = framesPerBuffer;
//        unsigned flag = FFTW_MEASURE;
//        app.plan = fftw_plan_dft_r2c_1d((int)BUF_SIZE, app.pWindowed, app.pFreq , flag);
//        app.plan = fftw_plan_r2r_1d(BUF_SIZE, app.pWindowed, app.pFreq, FFTW_REDFT00 , flag);
        [app.vibView setBuffer:(app.pinBuf) size:BUF_SIZE];
        [app.frView setBuffer:app.pFreq size:BUF_SIZE rate:SAMPLE_RATE ];
    }
    
    long int n;
    for( n=0 ; n < BUF_SIZE-framesPerBuffer; n++){
        //shifting the data from the past to bothside
        app.pinBuf[BUF_SIZE-1-n] = app.pinBuf[BUF_SIZE-framesPerBuffer-1-n];
    }
    //new signal generated from the middle :)
    for (n=0; n<framesPerBuffer; n++) {
        app.pinBuf[framesPerBuffer-n] = (double)in[n];
    }
    

//    for (n=0; n<BUF_SIZE; n++) {
//        app.pWindowed[n] = app.pinBuf[n];
//        app.pWindowed[n] *= 0.5*(1-sin( M_PI*n/(BUF_SIZE-1)/2) ); // Hann windowing
//        app.pWindowed[n] *= exp(-0.007*fabs(n));//poisson window
//    }

//    fftw_execute(app.plan);

    //my own transform
    
    int firstCode = freq2CodeNo(55.0);
    int lastCode = order2CodeNo((int)BUF_SIZE);
    
    for (int k=firstCode; k<lastCode; k++) {
        [app get3PowerOfCodeNo:k];
    }
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
-(void)get3PowerOfCodeNo:(int)code{
    int order;
    order = codeNo2OrderLower(code);
    [self getPowerOfOrder:order];
    order = codeNo2OrderRound(code);
    [self getPowerOfOrder:order];
    order = codeNo2OrderHigher(code);
    [self getPowerOfOrder:order];

}
-(void)getPowerOfOrder:(int)order{
    int div = 4; // this number is the key of speed!!!
    double cossum = 0;
    double sinsum = 0;
//    double fx, cosnwt, sinnwt;
    int scale = div - div*order/BUF_SIZE;
    int n2;
    
    for (int n=0; n < BUF_SIZE/order*64 && n < BUF_SIZE; n+= scale) {
//    for (int n=0; n < BUF_SIZE*scale/div; n+= scale) {
//        fx = _pWindowed[n];
//        cosnwt = cos(M_PI*order/BUF_SIZE*n);
//        sinnwt = sin(M_PI*order/BUF_SIZE*n);
//        cossum += fx*cosnwt;
//        sinsum -= fx*sinnwt;
        n2 = n+rand()%scale;
        cossum += _pinBuf[n2]*cos(M_PI*order/BUF_SIZE*n2)*0.5*(1-sin( M_PI*n/(BUF_SIZE/order*64-1)/2) );
        sinsum -= _pinBuf[n2]*sin(M_PI*order/BUF_SIZE*n2)*0.5*(1-sin( M_PI*n/(BUF_SIZE/order*64-1)/2) );
    }
    
    _pFreq[order][0] = cossum/log(BUF_SIZE/order*64)/log(BUF_SIZE/order*64);
    _pFreq[order][1] = sinsum/log(BUF_SIZE/order*64)/log(BUF_SIZE/order*64);
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
