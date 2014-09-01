//
//  ASTrasnform.m
//  audiosound
//
//  Created by qjinp on 8/20/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#import "ASTrasnform.h"

@implementation ASTrasnform
-(id)init{
    self = [super init];
    if (self){
        _pFreq = NULL;
        _pInBuf = NULL;
        _freqSize = 0;
        _inputSize = 0;
    }
    return self;
}


-(void)setInputSize:(int)inbufSize frqBufSize:(int)frqsize{
    if(_inputSize!= inbufSize){
        _inputSize = inbufSize;
        if (_pInBuf != NULL){
            free(_pInBuf);
        }
        _pInBuf = malloc(sizeof(double)*_inputSize);
        
    }
    if(_freqSize!= frqsize){
        _freqSize = frqsize;
        
        if(_pFreq != NULL){
            free(_pFreq);
        }
        _pFreq = malloc(sizeof(double)*_freqSize);
        
        [_frView setBuffer:_pFreq size:(CODE_HIGHST-CODE_A1)*3 rate:SAMPLE_RATE ];
    }
}
-(void)setApp:(AppDelegate *)appD freqView:(ASFreqView*)frV
{
    _app = appD;
    _frView = frV;
}

-(void)dealloc{
    if(_pFreq != NULL){
        free(_pFreq);
    }
    _pFreq = NULL;
}

-(void)startCalc
{
    _running = YES;
    [self start];
}

-(void)main{
    //my own foureier transform
    //only gets 3 freq per each code
    //with the seperated sample langth
    while(_running){
        @synchronized(_app){
            memcpy(_pInBuf, _app.pinBuf, sizeof(double)*_inputSize);
        }
        
        for (int k=CODE_A1; k<CODE_HIGHST; k++) {
            [self get3PowerOfCodeNo:k];
        }
        [_frView setNeedsDisplay:YES];
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
    int scale = 2 - 2*order/BUF_SIZE;
    
    //    scale = 1;
    
    int length = (int)BUF_SIZE/order*128;
    int loopEnd = (length < BUF_SIZE)?length:(int)BUF_SIZE;
    
    for (int n=0; n < loopEnd; n+= scale ) {
        fx = _pInBuf[n] * (0.54+0.46*cos(M_PI*n/(loopEnd-1))) ;
        cosnwt = cos(M_PI*order/BUF_SIZE*n);
        sinnwt = sin(M_PI*order/BUF_SIZE*n);
        cossum += fx*cosnwt;
        sinsum -= fx*sinnwt;
    }
    
    return sqrt((cossum*cossum + sinsum*sinsum)/loopEnd);
}



@end
