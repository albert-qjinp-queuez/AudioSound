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
    
	
    
    CGFloat wPoint;
    for (unsigned long i = 1; i < _size; i++) {
        wPoint = i * w / _size ;
        [path moveToPoint:(NSPoint){ wPoint, 2}];
        [path lineToPoint:(NSPoint){ wPoint , _pBuf[i]*h+2}];
        
    }
    
	[[NSColor blackColor] set];
	[path stroke];
}
-(void)setBuffer:(double*)inbuf size:(long int)size rate:(long int)rate{
    _pBuf = inbuf;
    _size = size;
    _rate = rate;
}


@end
