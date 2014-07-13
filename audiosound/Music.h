//
//  Music.h
//  audiosound
//
//  Created by qjinp on 7/11/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#ifndef audiosound_Music_h
#define audiosound_Music_h

int getCodeNo(int oct, int scale);
int getScale(int code);
int getOct(int code);
int freq2CodeNo(double freq);
double CodeNo2FreqRound(int code);
double CodeNo2FreqFloor(int code);
double CodeNo2FreqCeil(int code);
extern char* cStrCode[];
#endif
