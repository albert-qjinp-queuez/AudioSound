//
//  ASFreqView.m
//  audiosound
//
//  Created by qjinp on 6/20/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#import "ASFreqView.h"

@implementation ASFreqView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _pBuf = NULL;
        _pCopy = NULL;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    // Drawing code here.
    
	NSBezierPath* path = [NSBezierPath bezierPath];
    
    CGFloat h = [self frame].size.height;
    CGFloat w = [self frame].size.width;
    
    [path moveToPoint:(NSPoint){0,0}];
    [path lineToPoint:(NSPoint){0,h}];
    [path lineToPoint:(NSPoint){w,h}];
    [path lineToPoint:(NSPoint){w,0}];
    [path closePath];
	[[NSColor whiteColor] set];
    [path fill];
    
    double max=1;
    float sum=0;
    long int maxInex = 0;
    memcpy(_pCopy, _pBuf, sizeof(double)*_size);
    if (_pCopy != NULL) {
        
        _pCopy[0] = fabs(_pCopy[0]);
        _pCopy[_size-1] = fabs(_pCopy[_size-1]);
        for (int i = 1; i < _size; i++) {
            if (i <= _size/2) {
                _pCopy[i] = fabs(_pCopy[i]);
                _pCopy[_size-i-1] = fabs(_pCopy[_size-i-1]);
            }
            
            if(_pCopy[i] > _pCopy[i-1]) _pCopy[i-1] = 0;
            if(_pCopy[_size-i] < _pCopy[_size-i-1]) _pCopy[_size-i] = 0;
            
            if( max < _pCopy[i]){
                max = _pCopy[i];
                maxInex = i;
            }
            sum+=_pCopy[i];
        }
        
        if (_size != 0) sum = sum/_size;
        
        if (max == 0) max = 1;
        
        for (int i = 0; i < _size; i++) {
            if(_pCopy[i] < _noise.doubleValue){
                _pCopy[i] = 0;
            }else{
//                [_scaleView size:_pCopy[i] freq:i time:0];
            }
            _pCopy[i] = _pCopy[i]/max;
        }
        
        _maxFreqLabel.doubleValue = ((double)maxInex)/_size *_rate /2.0;
        
        
        CGFloat wPoint;
        for (unsigned long i = 1; i < _size; i++) {
            wPoint = i * w / _size ;
            [path moveToPoint:(NSPoint){ wPoint, 2}];
            [path lineToPoint:(NSPoint){ wPoint , _pCopy[i]*h+2}];
            
        }
//        _scaleView.needsDisplay = YES;
    }
	[[NSColor blackColor] set];
	[path stroke];
    
	NSBezierPath* noisePath = [NSBezierPath bezierPath];
    [noisePath moveToPoint:(NSPoint){ 0 , _noise.doubleValue/max*h+2}];
    [noisePath lineToPoint:(NSPoint){ w , _noise.doubleValue/max*h+2}];
	[[NSColor redColor] set];
	[noisePath stroke];
}
-(void)setBuffer:(double*)inbuf size:(long int)size rate:(long int)rate{
    _size = size;
    _rate = rate;
    _pBuf = inbuf;
    if (_pCopy != NULL) {
        free(_pCopy);
    }
    _pCopy = malloc(sizeof(double)*size);

}


@end
