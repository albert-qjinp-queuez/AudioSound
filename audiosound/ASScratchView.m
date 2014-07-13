//
//  ASScratchView.m
//  audiosound
//
//  Created by qjinp on 6/23/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#import "ASScratchView.h"
#import "AppDelegate.h"

static NSString* strCode[] = {@"A", @"A#", @"B", @"C", @"C#", @"D", @"D#", @"E", @"F", @"F#", @"G", @"G#"};


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
    double lpTime = a.lastPlayTime;
    
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
    
    NSBezierPath* soundPath = [NSBezierPath bezierPath];
    
    for (int i=0; i<_sounds.count; i++) {
        sound = [_sounds objectAtIndex:i];
        double po = (lpTime - sound.time)*_spead.doubleValue ;
        if ( po < winX) {
            int scale = getScale(sound.code);
            int oct = getOct(sound.code);
            if (po < winX/256){
              [strCode[scale] drawAtPoint:(NSPoint){ 0 , ((double)scale+ oct*12) / 12.0/8 * winY} withAttributes:attributes];
            }
            [soundPath moveToPoint:(NSPoint){ po+(winX*_spead.doubleValue/8192)-sound.code*(_spead.doubleValue/4096)  , (sound.code-sound.size/100.0) / 12.0/8 * winY}];
            [soundPath lineToPoint:(NSPoint){ po+(winX*_spead.doubleValue/8192)-sound.code*(_spead.doubleValue/4096)  , (sound.code+sound.size/100.0) / 12.0/8 * winY }];
            
        }else{
            [_sounds removeObjectAtIndex:i];
            i--;
        }
    }
    [[NSColor blueColor] set];
    [soundPath stroke];
}

- (void)size:(double)size freq:(double)freq time:(double)time {
    AppDelegate * a = _app;
    double lpTime = a.lastPlayTime;
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
