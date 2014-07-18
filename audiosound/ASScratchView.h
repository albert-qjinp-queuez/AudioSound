//
//  ASScratchView.h
//  audiosound
//
//  Created by qjinp on 6/23/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>
#import "Music.h"


@interface ASChartTime : NSObject
@property (assign) double time;
@property (assign) double* codes;
@property (assign) int size;
@end

@interface ASScratchView : NSView

@property (assign) IBOutlet id app;
@property (assign) IBOutlet NSSlider* speed;
@property (retain) NSMutableArray * sounds;
@property (assign) double sTime;

- (void)code:(struct codePower*)_pCode size:(int)size;

@end
