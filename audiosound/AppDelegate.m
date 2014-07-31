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
//        app.pWindowed = NULL;
    }
    if (app.pinBuf == NULL){
        app.pinBuf = malloc(sizeof(double)*BUF_SIZE);
        app.pFreq = malloc(sizeof(double)*(CODE_HIGHST-CODE_A1)*3);
//        app.pWindowed = malloc(sizeof(double)*BUF_SIZE);

        app.size = framesPerBuffer;
//        unsigned flag = FFTW_MEASURE;
//        app.plan = fftw_plan_dft_r2c_1d((int)BUF_SIZE, app.pWindowed, app.pFreq , flag);
//        app.plan = fftw_plan_r2r_1d(BUF_SIZE, app.pWindowed, app.pFreq, FFTW_REDFT00 , flag);
        [app.vibView setBuffer:(app.pinBuf) size:BUF_SIZE];
        [app.frView setBuffer:app.pFreq size:(CODE_HIGHST-CODE_A1)*3 rate:SAMPLE_RATE ];
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
    [app CFT];

    app.prvTime = timeInfo->inputBufferAdcTime;
    return 0;
}


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    _err = Pa_Initialize();
    initMusic();
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
-(void)CFT{
    //my own foureier transform
    //only gets 3 freq per each code
    //with the seperated sample langth
    
    for (int k=CODE_A1; k<CODE_HIGHST; k++) {
        [self get3PowerOfCodeNo:k];
    }
}

-(void)get3PowerOfCodeNo:(int)code{
    int order;
    int code2 = (code - CODE_A1)*3;
    order = codeNo2OrderLower(code);
    _pFreq[code2] = [self getPowerOfOrder:order];
    order = codeNo2OrderRound(code);
    _pFreq[code2+1] = [self getPowerOfOrder:order];
    order = codeNo2OrderHigher(code);
    _pFreq[code2+2] = [self getPowerOfOrder:order];

}
-(double)getPowerOfOrder:(int)order{
    double cossum = 0;
    double sinsum = 0;
    double fx, cosnwt, sinnwt;
//    int n2;
//    int div = 4; // this number is the key of speed!!!
//    int scale = div - div*order/BUF_SIZE;
//    int scale = 1;
    
    int loopEnd = (BUF_SIZE/order*128 < BUF_SIZE)?(int)BUF_SIZE/order*64:(int)BUF_SIZE;
    
    for (int n=0; n < loopEnd; n++) {
        fx = _pinBuf[n] * (0.54+0.46*cos(M_PI*n/(loopEnd-1)));
        cosnwt = cos(M_PI*order/BUF_SIZE*n);
        sinnwt = sin(M_PI*order/BUF_SIZE*n);
        cossum += fx*cosnwt;
        sinsum -= fx*sinnwt;
    }
    
    return sqrt(cossum*cossum + sinsum*sinsum);
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
//    fftw_destroy_plan(_plan);
    free(_pinBuf);
//    free(_pWindowed);
    free(_pFreq);
    CFBridgingRelease(_pSelf);
    _err = Pa_StopStream( _stream );
    
    _err = Pa_Terminate();
}

@end
