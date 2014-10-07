//
//  ASChartView.h
//  audiosound
//
//  Created by qjinp on 9/1/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>
#import "ASTextGuitarTab.h"

@interface ASChartView : NSView{
    enum {CHART_HEAD, CHART_BODY} parseState;
//    int lineWidth;
    enum { CHART_GUITARTABO, CHART_UNKNOWN} type;
}
@property (retain) NSString * title;
@property (retain) NSArray * lines;
@property (assign) double currentPos;
@property (assign) IBOutlet NSLayoutConstraint *viewHeight;
@property (assign) IBOutlet NSSlider *sliderCurrentPos;
@property (assign) IBOutlet NSTextField *textCurrentPos;

@property (retain) ASTextGuitarTab *chart;//TODO:: Make interface

-(void)readFile:(NSURL*)fURL;
-(void)removeFile;
-(IBAction)posChange:(id)sender;
@end
