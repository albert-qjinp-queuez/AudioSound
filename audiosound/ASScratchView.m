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



@implementation ASChartTime
-(id) initWithCodePower:(struct codePower*)pCode size:(int)size time:(double)time{
    self = [super init];
    if (self) {
        _time = time;
        _size = size;
        _codes = malloc(sizeof(double)*_size);
        for (int i=0; i<12; i++) {
            _chordSum[i].chordNum = i;
            _chordSum[i].power = 0;
        }
        for (int i = 0; i<_size; i++) {
            _codes[i] = pCode[i].size;
            _chordSum[i%12].power += _codes[i];
        }
    }
    return self;
}
+ (id)alloc {
    id this =[super alloc];
    return this;
}
- (void)dealloc {
    free(_codes);
}
-(NSString*) getChordset{
    //sort _chordSum by power
    struct Chord tmpChord;
    for (int i=0; i<12; i++) {
        for (int j=i; j<12; j++) {
            if (_chordSum[i].power < _chordSum[j].power) {
                tmpChord = _chordSum[i];
                _chordSum[i] = _chordSum[j];
                _chordSum[j] = tmpChord;
            }
        }
    }
    //find maximumGap
    double maxGap = 0.0;
    int gapPos = 0;
    for (int i=0; i<11; i++) {
        double gap = _chordSum[i].power-_chordSum[i+1].power;
        if (gap>maxGap) {
            maxGap = gap;
            gapPos = i+1;
        }
        
    }
    //join the chords above maximumGap
    NSMutableString* strChords = [[NSMutableString alloc]initWithCapacity:24];
    [strChords setString:@""];
    for (int i=0; i<gapPos; i++) {
        [strChords appendString:strCode[_chordSum[i].chordNum]];
    }
    
    return [NSString stringWithString:strChords];
}

@end


@implementation ASScratchView

+ (NSString*) strCode:(int)code {
    NSString* strCodes[] ={ @"A", @"A#", @"B", @"C", @"C#", @"D", @"D#", @"E", @"F", @"F#", @"G", @"G#" };
    return strCodes[code];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _sounds = [[NSMutableArray alloc]init];
        _sTime = 0.0;
        _codes = NULL;
    }
    return self;
}

- (void)dealloc {
    if (_codes != NULL) {
        free(_codes);
    }
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
//    NSDictionary *attributes = @{NSFontAttributeName: [NSFont fontWithName:@"Verdana" size:11]};
    
    NSBezierPath* soundPath = [NSBezierPath bezierPath];
    double max = 0.0;
    int maxInt = 0;
    if (_sounds.count > 0){
        ASChartTime * sound = [_sounds objectAtIndex:0];
        for(int j=0;j < sound.size; j++){
            _codes[j] =0;
        }
        for (int i=0; i<10; i++) {
            
            sound = [_sounds objectAtIndex:_sounds.count-1-i];
            if( _codes!= NULL){
                for(int j=0;j < sound.size; j++){
                    _codes[j] += sound.codes[j]*(10-i);
                    if (max < _codes[j]) {
                        max = _codes[j];
                        maxInt = j;
                    }
                }
            }
        }
        _maxFreqLabel.stringValue = [ASScratchView strCode:((maxInt))%12];
        sound = [_sounds objectAtIndex:_sounds.count-1];
        _textChords.stringValue = [sound getChordset];
        for (int i=0; i<_sounds.count; i++) {
            
            ASChartTime * sound = [_sounds objectAtIndex:i];
            double po = (lpTime - sound.time)*_speed.doubleValue ;
            
            if ( po < winX) {
                for (int j=0; j<sound.size; j++) { // scaled from j = 0, A1 - 55.0Hz for each
                    [soundPath
                     moveToPoint:(NSPoint){
                         po+(winX*_speed.doubleValue/8192)-(winX*_speed.doubleValue*j/1024/128)
                         , (((double)j)-sound.codes[j]) / sound.size * winY
                     }];
                    [soundPath
                     lineToPoint:(NSPoint){
                         po+(winX*_speed.doubleValue/8192)-(winX*_speed.doubleValue*j/1024/128)
                         , (((double)j)+sound.codes[j]) / sound.size * winY
                     }];
                }
            }else{
                [_sounds removeObjectAtIndex:i];
                i--;
            }
        }
        [[NSColor blueColor] set];
        [soundPath stroke];
    }
}


- (void)code:(struct codePower*)pCode size:(int)size{
    AppDelegate * a = _app;
    double lpTime = a.lastPlayTime;
    if (_sTime == 0) {
        _sTime = lpTime;
    }
    ASChartTime * chart = [[ASChartTime alloc]initWithCodePower:pCode size:size time:lpTime];
    [_sounds addObject:chart];
    if (_codes == NULL) {
        _codes = malloc(sizeof(double)*size);
    }
}


@end
