//
//  ASTextGuitarTab.h
//  audiosound
//
//  Created by qjinp on 9/18/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASBit : NSObject
@property (retain) NSArray * notes;
-(id)initWithNote:(NSArray*)pair ;
@end

@interface ASMeasures : NSObject
@property (assign) int number;
@property (retain) NSMutableArray * bits;
-(id)initWithMNumber:(int)measureNum;
-(void)insertNote:(NSString*)notes;

@end

@interface ASTextGuitarTab : NSObject
@property (retain) NSMutableDictionary * measure;
@property (retain) NSString* measureNum;

-(void) parse:(NSString*)line;
-(void) draw:(NSRect)dirtyRect time:(long int )curPos;
-(ASMeasures*) getMeasure:(long int)mNum;
@end
