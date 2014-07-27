//
//  Music.h
//  audiosound
//
//  Created by qjinp on 7/11/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#ifndef audiosound_Music_h
#define audiosound_Music_h

extern long int BUF_SIZE;
extern long int SAMPLE_SIZE;
extern long int SAMPLE_RATE;


struct codePower {
    double size;
    int count;
};
int codeNo2OrderRound(int codeNo);
int codeNo2OrderLower(int codeNo);
int codeNo2OrderHigher(int codeNo);

int order2CodeNo(int order);

double order2freq(int num);
int freq2order(double freq);

int getCodeNo(int oct, int scale);
int getScale(int code);
int getOct(int code);

int freq2CodeNo(double freq);

double CodeNo2FreqRound(int code);
double CodeNo2FreqFloor(int code);
double CodeNo2FreqCeil(int code);
double CodeNo2FreqLower(int code);
double CodeNo2FreqHigher(int code);

extern char* cStrCode[];

#endif
