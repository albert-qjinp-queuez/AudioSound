//
//  ASVibrationView.h
//  audiosound
//
//  Created by qjinp on 6/14/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ASVibrationView : NSView

@property (assign) double *pBuf;
@property (assign) unsigned long size;
@property (assign) double noiseLv;
@property (assign) IBOutlet NSSlider* noise;

-(void)setBuffer:(double*)inbuf size:(long int)size;

@end
