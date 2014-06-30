//
//  ASVibrationView.m
//  audiosound
//
//  Created by qjinp on 6/14/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#import "ASVibrationView.h"

@implementation ASVibrationView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _pBuf = NULL;
        _size = 0;
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
    
	[path moveToPoint:(NSPoint){0,h/2}];
    for (unsigned long i = 1; i < _size; i++) {
        CGFloat wPoint = i * w / _size;
        [path lineToPoint:(NSPoint){ wPoint , (_pBuf[i]*h)+h/2 }];
    }
	//[path closePath];
    
	[[NSColor blackColor] set];
	[path stroke];
    
	NSBezierPath* noisePath = [NSBezierPath bezierPath];
    [noisePath moveToPoint:(NSPoint){ 0 , h/2+_noise.doubleValue}];
    [noisePath lineToPoint:(NSPoint){ w , h/2+_noise.doubleValue }];
    [noisePath moveToPoint:(NSPoint){ 0 , h/2-_noise.doubleValue}];
    [noisePath lineToPoint:(NSPoint){ w , h/2-_noise.doubleValue }];
	[[NSColor redColor] set];
	[noisePath stroke];
    // Drawing code here.
}

-(void)setBuffer:(double*)inbuf size:(long int)size{
    _pBuf = inbuf;
    _size = size;
}

@end
