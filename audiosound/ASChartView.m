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
    
    NSDictionary *attributes =
        [NSDictionary dictionaryWithObjectsAndKeys:
            [NSFont boldSystemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName, nil];
    
    
    [super drawRect:dirtyRect];
    // Drawing code here.
    [[NSColor whiteColor] set];
    NSRectFill(self.bounds);
    
    NSBezierPath* linesPath = [NSBezierPath bezierPath];
    
    long int curPos = _sliderCurrentPos.intValue;
    
    for (long int i = curPos; i < curPos+50; i++) {
        ASMeasures* mea = [_chart getMeasure:i];
        unsigned long int bitCount = [mea.bits count];
        for(unsigned long int j = 0; j < bitCount; j++) {
            ASBit * bit = [mea.bits objectAtIndex:j];
            unsigned long int noteCount = [bit.notes count];
            for (unsigned long int k=0; k<noteCount; k++) {
                NSString* key = [bit.notes objectAtIndex:k];
                if ([key compare:@"X"] != NSOrderedSame) {
                    [key drawAtPoint: (NSPoint){j * 160/bitCount + (i-curPos) * 160, 85 - 13*k} withAttributes:attributes];
                }
            }
        }
        [linesPath
         moveToPoint:(NSPoint){(i-curPos) * 160, 0.0}];
        [linesPath
         lineToPoint:(NSPoint){(i-curPos) * 160, 100.0}];
    }
    [[NSColor blueColor] set];
    [linesPath stroke];
    
    
}
-(void)readFile:(NSURL*)fURL{
    NSError *error;
    [self removeFile];
    
    NSString * filerep = [NSString stringWithContentsOfURL:fURL encoding:NSUTF8StringEncoding error:&error];
    _lines = [filerep componentsSeparatedByString:@"\n"];
    
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
    _sliderCurrentPos.intValue = 1;
    _sliderCurrentPos.minValue = 1;
    _sliderCurrentPos.maxValue = _chart.measure.count;
    _sliderCurrentPos.numberOfTickMarks = _chart.measure.count;
    _lines = nil;
    _viewHeight.constant = 100;
    [self setNeedsLayout:YES];
}
-(void)removeFile{
    _chart = nil;
    _viewHeight.constant = 0;
    [self setNeedsLayout:YES];
}
-(IBAction)posChange:(id)sender{
    [self needsToDrawRect:self.bounds];
    self.needsDisplay = YES;
}
@end
