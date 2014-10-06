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
    
    if ( app.prvTime == -1.0) {
        app.prvTime = timeInfo->inputBufferAdcTime;
    }
    

    //my own transform
    [app CFT:in time:timeInfo->inputBufferAdcTime];
    
    return 0;
}


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    if (_pinBuf == NULL){
        _pinBuf = malloc(sizeof(double)*BUF_SIZE);
        _size = SAMPLE_SIZE;
    }
    _prvTime = -1.0;
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
    
    _myTrasnform = [[ASTrasnform alloc]init];
    [_myTrasnform setApp:self freqView:_frView];
    [_myTrasnform setInputSize:BUF_SIZE frqBufSize:(CODE_HIGHST-CODE_A1)*3];
    [_myTrasnform startCalc];

}
-(void)CFT:(float*)inbuf time:(double)time{
    _lastPlayTime = time;
    double timeDiff = time - _prvTime;
    double zeroSpace = (double)timeDiff*(double)SAMPLE_RATE;
    
    long int n;
    long int shiftSize = (zeroSpace < BUF_SIZE)?zeroSpace:(int)BUF_SIZE;
    if (shiftSize < 0) {
        shiftSize = BUF_SIZE;
    }
    
    @synchronized(self){
        for( n=shiftSize ; n < BUF_SIZE; n++){
            //shifting the data from the past to bothside
            _pinBuf[BUF_SIZE-1-n+shiftSize] = _pinBuf[BUF_SIZE-1-n];
        }
        for (n=_size; n < shiftSize;  n++) {
            _pinBuf[n] = 0;
        }
        //new signal generated from the middle :)
        for (n=0; n<_size; n++) {
            _pinBuf[_size-n] = (double)inbuf[n];
        }
    }
    _prvTime = time;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    free(_pinBuf);
//    free(_pFreq);
    CFBridgingRelease(_pSelf);
    _err = Pa_StopStream( _stream );
    
    _err = Pa_Terminate();
}
- (IBAction)openDocument:(id)sender{
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    
    // This method displays the panel and returns immediately.
    // The completion handler is called when the user selects an
    // item or cancels the panel.
    [panel beginWithCompletionHandler:^(NSInteger result){

        NSURL* theDoc;

        if (result == NSFileHandlingPanelOKButton) {
            theDoc = [[panel URLs] objectAtIndex:0];
            // Open  the document.
            
            [_chartView readFile:theDoc];
        }
    }];
    
}
@end
