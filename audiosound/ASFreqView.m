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
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
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
    
	[path moveToPoint:(NSPoint){0,0}];
    double max=0;
    float sum=0;
    int maxInex = 0;
    for (int i = 1; i < _size; i++) {
        if( max < fabs(_pBuf[i])){
            max = fabs(_pBuf[i]);
            maxInex = i;
        }
        sum+=fabs(_pBuf[i]);
    }
    if(_size != 0) sum = sum/_size;
    max = max-sum;
    if (max <= 0)max = 1;

    
    CGFloat wPoint;
    CGFloat hPoint;
    for (unsigned long i = 1; i < _size; i++) {
        wPoint = i * w / _size ;
        
        hPoint = fabs(_pBuf[i]);
        if (sum > hPoint) hPoint = 0;
        else hPoint= hPoint-sum;
        
        [path lineToPoint:(NSPoint){ wPoint , hPoint /max*h}];
    }
	//[path closePath];
//#define SAMPLE_RATE (8192)
//#define BUFSIZE (1024)
    
    _text.doubleValue = ((double)maxInex)*4;//1024.0 *8192.0 /2.0;
    [path moveToPoint:(NSPoint){0,sum/max*h}];
    [path lineToPoint:(NSPoint){w,sum/max*h}];
    
	[[NSColor blackColor] set];
	[path stroke];
    // Drawing code here.
}
-(void)setBuffer:(double*)inbuf size:(long int)size{
    _pBuf = inbuf;
    _size = size;
}


@end
