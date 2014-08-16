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

struct Chord{
    int chordNum;
    double power;
};
@interface ASChartTime : NSObject{
    struct Chord _chordSum[12];
}
@property (assign) double time;
@property (assign) double* codes;
@property (assign) int size;

-(NSString*) getChordset;
@end


@interface ASScratchView : NSView

@property (assign) IBOutlet NSTextField* maxFreqLabel;
@property (assign) IBOutlet NSTextField* textChords;
@property (assign) IBOutlet id app;
@property (assign) IBOutlet NSSlider* speed;
@property (retain) NSMutableArray * sounds;
@property (assign) double sTime;
@property (assign) double* codes;

- (void)code:(struct codePower*)_pCode size:(int)size;

@end
