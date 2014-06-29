//
//  ASScratchView.h
//  audiosound
//
//  Created by qjinp on 6/23/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ASChartNote : NSObject

-(id)initWith:(double)freq size:(double)size;
@property (assign) double freq;
@property (assign) double size;
@property (assign) int octave;
@property (assign) NSString* code;
@end

@interface ASChartTime : NSObject
@property (assign) double time;
@property (retain) NSMutableArray  * note;
- (void)time:(double)time freq:(double)freq size:(double)size;
@end


@interface ASChart : NSObject
-(void)size:(double)size freq:(double)freq time:(double)time;
@property (retain) NSMutableDictionary * chart;
@end


@interface ASScratchView : NSView

@property (retain) ASChart *chart;

- (void)add:(double)size on:(double)freq at:(double)time;


@end
