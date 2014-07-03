//
//  ASScratchView.h
//  audiosound
//
//  Created by qjinp on 6/23/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>


@interface ASSoundItem : NSObject
@property (assign) double time;
@property (assign) int code;
@property (assign) double size;

@end

@interface ASScratchView : NSView

@property (assign) IBOutlet id app;
@property (retain) NSMutableArray * sounds;
@property (assign) double sTime;

- (void)size:(double)size freq:(double)freq time:(double)time;


@end
