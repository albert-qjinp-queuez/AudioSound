//
//  ASChartView.m
//  audiosound
//
//  Created by qjinp on 9/1/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#import "ASChartView.h"

@implementation ASChartView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _viewHeight.constant = 0;
        [self setNeedsLayout:YES];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    // Drawing code here.
    
    
}
-(void)readFile:(NSURL*)fURL{
    
    
    NSError *error;
    [self removeFile];
    _currentPos = 0.0;
    
    NSString * filerep = [NSString stringWithContentsOfURL:fURL encoding:NSUTF8StringEncoding error:&error];
    _lines = [filerep componentsSeparatedByString:@"\n"];
    
    
    [self setNeedsLayout:YES];
    
    parseState = CHART_HEAD;
    NSArray *pair;
    NSString * key;
    NSString * val;

    for(NSString* itter in _lines){
        switch (parseState) {
            case CHART_HEAD:
            {
                pair = [itter componentsSeparatedByString:@":"];
                key = [pair objectAtIndex:0];

                if([key compare:@"VERSION"] == NSOrderedSame){
                    
                }else if ([key compare:@"TYPE"] == NSOrderedSame){
                    val = [pair objectAtIndex:1];
                    if( [val compare:@"GUITARTABO"] == NSOrderedSame){
                        type = CHART_GUITARTABO;
                        if (_chart != nil) {
                            //[_chart dealloc];
                        }
                        _chart = [[ASTextGuitarTab alloc]init];
                    }else{
                        type = CHART_UNKNOWN;
                    }
                }else if ([key compare:@"TITLE"] == NSOrderedSame){
                    _title = [pair objectAtIndex:1];
                }else if ([key compare:@"TabStart"] == NSOrderedSame){
                    parseState = CHART_BODY;
                }
            }
                break;
            case CHART_BODY:
            {
                [_chart parse:itter];
            }
                break;
                
            default:
                break;
        }
    }
    _lines = nil;
    _viewHeight.constant = 100;
}
-(void)removeFile{
    _chart = nil;
}
@end