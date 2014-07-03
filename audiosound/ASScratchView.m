//
//  ASScratchView.m
//  audiosound
//
//  Created by qjinp on 6/23/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#import "ASScratchView.h"
#import "AppDelegate.h"

static NSString* code[] = {@"A", @"A#", @"B", @"C", @"C#", @"D", @"D#", @"E", @"F", @"F#", @"G", @"G#"};


int getCodeNo(int oct, int scale){
    return oct*12 + scale;
}
int getScale(int code){
    return abs(code%12);
}
int getOct(int code){
    return code/12;
}
int freq2CodeNo(double freq){
    double rt12 = cbrt(sqrt(sqrt(2.0)));
    double theCode = (freq/(double)440/rt12);
    double a = log(theCode)/log(rt12);
    return round(a);
}

@implementation ASSoundItem
@end
@implementation ASScratchView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _sounds = [NSMutableArray arrayWithCapacity:500];
        _sTime = 0.0;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    AppDelegate * a = _app;
    double lpTime = [a getLastPlayTime ];
    
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    [[NSColor whiteColor] set];
    NSRectFill(self.bounds);
    int winX = self.bounds.size.width;
    int winY = self.bounds.size.height;
    
    
//    lpTime - _sTime
    
    
    NSDictionary *attributes
    = @{NSFontAttributeName:
            [NSFont fontWithName:@"Verdana" size:11]};
    ASSoundItem * sound;
    for (int i=0; i<_sounds.count; i++) {
        sound = [_sounds objectAtIndex:i];
        double po = (lpTime - sound.time)*10;
        if ( po < winX) {
            int scale = getScale(sound.code);
            [code[scale] drawAtPoint:(NSPoint){ po , ((double)scale) / 12.0 * winY} withAttributes:attributes];
        }else{
            [_sounds removeObjectAtIndex:i];
            i--;
        }
    }
}

- (void)size:(double)size freq:(double)freq time:(double)time {
    AppDelegate * a = _app;
    double lpTime = [a getLastPlayTime ];
    if (_sTime == 0) {
        _sTime = lpTime;
    }

    int codeNo = freq2CodeNo(freq);
    ASSoundItem * item = [[ASSoundItem alloc]init];
    item.time = lpTime;
    item.code = codeNo;
    item.size = size;
    [_sounds addObject:item];
}


@end
