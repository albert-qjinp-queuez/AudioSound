//
//  ASTextGuitarTab.m
//  audiosound
//
//  Created by qjinp on 9/18/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#import "ASTextGuitarTab.h"
@implementation ASBit
-(id)initWithNote:(NSArray*) pair{
    if( self = [super init] ){
        _notes = [NSArray arrayWithArray:pair];
    }
    return self;
}
@end

@implementation ASMeasures

-(id)initWithMNumber:(int)measureNum{
    self = [super init];
    if(self){
        _bits = [NSMutableArray array];
        _number = measureNum;
    }
    return self;
}

-(void)insertNote:(NSString*)note{;
    NSArray *pair = [note componentsSeparatedByString:@" "];
    if([pair count] == 6){
        ASBit * bit = [[ASBit alloc]initWithNote:pair];
        [_bits addObject:bit];
    }
}
@end

@implementation ASTextGuitarTab

-(id)init{
    self = [super init];
    if(self){
        _measure = [[NSMutableDictionary alloc]init];
        _measureNum = nil;
    }
    return self;
}

-(void) parse:(NSString*)line
{
    NSArray *pair;
    ASMeasures* currentM;
    pair = [line componentsSeparatedByString:@" "];
    NSString * key;
    key = [pair objectAtIndex:0];
    if([key compare:@"------"] == NSOrderedSame){
        _measureNum = [pair objectAtIndex:1] ;
        currentM = [_measure objectForKey:_measureNum];
        if( currentM == nil ){
            currentM = [[ASMeasures alloc] initWithMNumber:_measureNum.intValue];
            [_measure setObject:currentM forKey:_measureNum];
        }

        
    }else if([key compare:@"======"] == NSOrderedSame){
        
    }else if([key compare:@"TabEnd"] == NSOrderedSame){
        _measureNum = nil;
    }else{
        //real tab info
        currentM = [_measure objectForKey:_measureNum];
        if(_measureNum != nil ){
            
            [currentM insertNote:line];
        }
    }
}
-(ASMeasures*) getMeasure:(long int)mNum{
    NSString * strNum = [NSString stringWithFormat:@"%ld", mNum];
    return [_measure objectForKey:strNum];
}

@end
