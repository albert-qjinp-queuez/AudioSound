//
//  ASScratchView.m
//  audiosound
//
//  Created by qjinp on 6/23/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#import "ASScratchView.h"

static double oct[] = {27.5, 55.0, 110.0, 220.0, 440.0, 880.0, 1760.0, 3520.0};
static double scale[] = {1, 1.06, 1.12, 1.19, 1.26, 1.33, 1.41, 1.5, 1.59, 1.68, 1.78, 1.89};
static NSString* code[] = {@"A", @"A#", @"B", @"C", @"C#", @"D", @"D#", @"E", @"F", @"F#", @"G", @"G#"};



@implementation ASChartNote
-(id)initWith:(double)freq size:(double)size{
    self = [super init];
    if (self) {
        _freq = freq;
        _size = size;
        int size = sizeof(oct)/sizeof(double);
        for (int i=0; i < size ;i++) {
            if (oct[i] <= freq && freq < oct[i+1]) {
                _octave = i;
                for (int j=0; j < sizeof(scale)/sizeof(double)-1; j++) {
                    if (oct[i] *scale[j] <= freq && freq < oct[i] *scale[j+1]) {
                        _code = code[j];
                        _codeNo = j;
                        break;
                    }
                }
                break;
            }
        }
    }
    return self;
}
@end

@implementation ASChartTime
-(id)initWithTime:(double)time{
    self = [super init];
    if (self) {
        _time = time;
        _note = [[NSMutableArray alloc]init];
        _codes = [[NSMutableSet alloc]initWithCapacity:12];
    }
    return self;
}
- (void)time:(double)time freq:(double)freq size:(double)size{
    if (_time != time) {
        _time = time;
    }
    ASChartNote* note = [[ASChartNote alloc]initWith:freq size:size ];
    [_note addObject:note];
    [_codes addObject:note.code];
}
@end

@implementation ASChart
-(id)init{
    self = [super init];
    if (self) {
        _chartDic = [[NSMutableDictionary alloc]init];
        _chartArr = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)size:(double)size freq:(double)freq time:(double)time{
    NSNumber *objTime = [NSNumber numberWithDouble:time];
    ASChartTime *chartTime =
      (ASChartTime *)[_chartDic objectForKey:objTime];
    
    if (chartTime == nil) {
        chartTime = [[ASChartTime alloc]initWithTime:time];
        [_chartDic setObject:chartTime forKey:objTime];
        [_chartArr addObject:chartTime];
    }
    [chartTime time:time freq:freq size:size];
}
-(void)drawChart{
    NSMutableParagraphStyle * paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSCenterTextAlignment];
    NSDictionary * attributes = [NSDictionary dictionaryWithObject:paragraphStyle forKey:NSParagraphStyleAttributeName];

    int yPos = 10;
    for (ASChartTime* cTime in _chartArr) {
        for( NSString* code in cTime.codes){
            [code drawAtPoint:(NSPoint){10,yPos} withAttributes:attributes];
            yPos += 14;
        }
    }
}
@end


@implementation ASScratchView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _chart = [[ASChart alloc]init];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    [[NSColor whiteColor] set];
    NSRectFill(self.bounds);
//    [_chart drawChart];
}

- (void)add:(double)size on:(double)freq at:(double)time{
    
    
    [_chart size:size freq:freq time:time];
}

@end
