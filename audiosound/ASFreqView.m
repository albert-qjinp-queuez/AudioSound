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
        _A1 = freq2CodeNo(55.0);//Guitar starts from E1 - 82.5Hz
        _A6 = freq2CodeNo(1760.0);//Guitar Ends B - 1162Hz
        _fqA1Lb = CodeNo2FreqCeil(_A1);
        _fqA6Lb = CodeNo2FreqFloor(_A6);
        
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
        memcpy(_pCopy, _pBuf, sizeof(double)*_size);
        
        //absoluting
        for (int i = 0; i < _size; i++) {
            _pCopy[i] = fabs(_pCopy[i]);
            _pCopy[_size-i-1] = fabs(_pCopy[_size-i-1]);
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
        for (int i=0; i<_A6-_A1; i++) {
            _pCode[i].size = 0.0;
            _pCode[i].count = 0;
        }
        
        for (int i = [self freq2order:_fqA1Lb]; i < [self freq2order:_fqA6Lb]; i++) {
            int codeNo = freq2CodeNo([self order2freq:i]);
            _pCode[codeNo - _A1].size = (_pCode[codeNo - _A1].size*_pCode[codeNo - _A1].count + _pCopy[i])/(_pCode[codeNo - _A1].count + 1);
            
            _pCode[codeNo - _A1].count ++;
            if (cdMax < _pCode[codeNo - _A1].size){
                cdMax  = _pCode[codeNo - _A1].size;
            }
        }
        
        //mak total avaerage
        if (_size != 0) sum = sum/_size;
        
        //to avoid devided by zero
        if (fqMax == 0) fqMax = 1;
        if (cdMax == 0) cdMax = 1;
        
        for (int i = 0; i < _size; i++) {
            if(_pCopy[i] > _noise.doubleValue && _pCopy[i] > fqMax/2){
//                [_scaleView size:_pCopy[i] freq:i time:0];
            }else{
//                _pCopy[i] = 0;
            }
            _pCopy[i] = _pCopy[i]/fqMax;
        }
        
        _maxFreqLabel.doubleValue = ((double)maxInex)/(double)_size*(double)_rate /2.0;
        
        
        CGFloat wPoint;
        
        //frequecy scale view
        [path moveToPoint:(NSPoint){ 0, 0}];
        for (unsigned long i = 1; i < _size; i++) {
            wPoint = i * w / _size ;
            [path lineToPoint:(NSPoint){ wPoint , _pCopy[i]*h}];
            
        }
        _scaleView.needsDisplay = YES;
        
        [[NSColor grayColor] set];
        [path stroke];
        
        //code scale view
        NSBezierPath* codePath = [NSBezierPath bezierPath];
        [[NSColor blueColor] set];
        for (int i=_A1; i<_A6; i++) {
            wPoint = [self freq2order: CodeNo2FreqRound(i)]*w/_size;
            [codePath moveToPoint:(NSPoint){ wPoint , 0}];
            [codePath lineToPoint:(NSPoint){ wPoint , _pCode[i-_A1].size*h/cdMax}];
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
    _pCode = malloc(sizeof(struct codeChart)*(_A6-_A1));

}
- (double)order2freq:(int)num{
    return num*_rate /2.0/_size;
}
- (int)freq2order:(double)freq{
    return freq * 2.0 * _size/ _rate;
}


@end
