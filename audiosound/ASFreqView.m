//
//  ASFreqView.m
//  audiosound
//
//  Created by qjinp on 6/20/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#import "ASFreqView.h"
#import "Music.h"

@implementation ASFreqView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _pBuf = NULL;
        _pCopy = NULL;
        _pCode = NULL;
        initMusic();
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    // Drawing code here.
    
    
    CGFloat h = [self frame].size.height;
    CGFloat w = [self frame].size.width;
    
	NSBezierPath* path = [NSBezierPath bezierPath];
    
    [path moveToPoint:(NSPoint){0,0}];
    [path lineToPoint:(NSPoint){0,h}];
    [path lineToPoint:(NSPoint){w,h}];
    [path lineToPoint:(NSPoint){w,0}];
    [path closePath];
    [[NSColor whiteColor] set];
    [path fill];
    
    
    double fqMax=0;
    double cdMax=0;
    float sum=0;
    long int maxInex = 0;
    
    if (_pCopy != NULL) {
        //copy freq data
        //memcpy(_pCopy, _pBuf, sizeof(double)*_size);
        
        for (int i = 0; i < _size; i++) {
            _pCopy[i] = 0;
        }
        
        //absoluting
        for (int i = 0; i < _size; i++) {
            _pCopy[i] += fabs(_pBuf[i]);
/*
            if (i+12 < _size && _pBuf[i]>_pBuf[i+12]) {
                _pCopy[i] += fabs(_pBuf[i+12])/4;
                _pCopy[i+12] -= fabs(_pBuf[i])/4;
                if (i+18 < _size && _pBuf[i]>_pBuf[i+18]) {
                    _pCopy[i] += fabs(_pBuf[i+18])/9;
                    _pCopy[i+18] -= fabs(_pBuf[i])/9;
                    if (i+24 < _size && _pBuf[i]>_pBuf[i+24]) {
                        _pCopy[i] += fabs(_pBuf[i+24])/16;
                        _pCopy[i+24] -= fabs(_pBuf[i])/16;
                    }else{
                        _pCopy[i] += fabs(_pBuf[i+18])/16;
                    }
                }else{
                    _pCopy[i] += fabs(_pBuf[i+12])/9;
                }
            }else{
                _pCopy[i] += fabs(_pBuf[i])/4;
            }
*/
        }
        for (int i = 1; i < _size; i++) {
            //Flatting non top items.
//            if(1 < i &&_pCopy[i] > _pCopy[i-2]) _pCopy[i-2] = 0;
//            if(1 < i && _pCopy[_size-i+1] < _pCopy[_size-i-1] ) _pCopy[_size-i+1] = 0;
            
            //Find Maximum
            if( fqMax < _pCopy[i]){
                fqMax = _pCopy[i];
                maxInex = i;
            }
            
            sum+=_pCopy[i];
        }
        
        //Summery of Code
        for (int i=0; i<_size/3; i++) {
            _pCode[i].size = 0.0;
            _pCode[i].count = 0;
        }
        
        for (int i = 0; i < _size; i++) {
            if (_pCopy[i] != 0.0) {
                _pCode[i/3].size +=  _pCopy[i];
                _pCode[i/3].count ++;
            }
        }
        
        for (int i=0; i<_size/3; i++) {
            if (_pCode[i].count == 0) _pCode[i].count = 1;
            _pCode[i].size = _pCode[i].size/_pCode[i].count;
            if (cdMax < _pCode[i].size) cdMax  = _pCode[i].size;
        }
        [_scaleView code:_pCode size:_size/3];
        
        //mak total avaerage
        if (_size != 0) sum = sum/_size;
        
        //to avoid devided by zero
        if (fqMax == 0) fqMax = 1;
        if (cdMax == 0) cdMax = 1;
        
        for (int i = 0; i < _size; i++) {
            _pCopy[i] = _pCopy[i]/fqMax;
        }
        
//        _maxFreqLabel.doubleValue = ((double)maxInex)/(double)_size*(double)_rate /2.0;
//        _maxFreqLabel.stringValue = [ASFreqView strCode: getScale(maxInex+CODE_A1)];
        
        CGFloat wPoint;
        
        //frequecy scale view
        [path moveToPoint:(NSPoint){ 0, 0}];
        for (unsigned long i = 0; i < _size; i++) {
            wPoint = i * w / _size;
            [path lineToPoint:(NSPoint){ wPoint , _pCopy[i]*h}];
            
        }
        _scaleView.needsDisplay = YES;
        
        [[NSColor grayColor] set];
        [path stroke];
        
        //code scale view
        NSBezierPath* codePath = [NSBezierPath bezierPath];
        [[NSColor blueColor] set];
        for (int i=0; i < _size/3; i++) {
            //wPoint = freq2order(CodeNo2FreqRound(i))*w/_size;
            wPoint = i * w /_size*3;
            [codePath moveToPoint:(NSPoint){ wPoint , 0}];
            [codePath lineToPoint:(NSPoint){ wPoint , _pCode[i].size*h/cdMax}];
        }
        [codePath stroke];
        
    }
    
    //noise egnoreance line
	NSBezierPath* noisePath = [NSBezierPath bezierPath];
    [noisePath moveToPoint:(NSPoint){ 0 , _noise.doubleValue/fqMax*h}];
    [noisePath lineToPoint:(NSPoint){ w , _noise.doubleValue/fqMax*h}];
    [[NSColor redColor] set];
    [noisePath stroke];
}
-(void)setBuffer:(double*)inbuf size:(long int)size rate:(long int)rate{
    _size = size;
    _rate = rate;
    _pBuf = inbuf;
    if (_pCopy != NULL) {
        free(_pCopy);
        free(_pCode);
    }
    
    _pCopy = malloc(sizeof(double)*size);
    _pCode = malloc(sizeof(struct codePower)*(size/3));

}
-(void) dealloc {
    if (_pCopy != NULL) {
        free(_pCopy);
        free(_pCode);
    }
}


@end
