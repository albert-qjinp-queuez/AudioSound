//
//  ASFreqView.h
//  audiosound
//
//  Created by qjinp on 6/20/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface ASFreqView : NSView

@property (assign) double *pBuf;
@property (assign) long int size;

@property (assign) IBOutlet NSTextField* text;

-(void)setBuffer:(double*)inbuf size:(long int)size;

@end
