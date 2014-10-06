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

-(void) pushTimes:(NSString*)times Measure:(int)measure;
-(void) parse:(NSString*)line;
@end
