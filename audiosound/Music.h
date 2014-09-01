//
//  Music.h
//  audiosound
//
//  Created by qjinp on 7/11/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#ifndef audiosound_Music_h
#define audiosound_Music_h

extern char* cStrCode[];

extern int BUF_SIZE;
extern int SAMPLE_SIZE;
extern int SAMPLE_RATE;
extern double BASE_FREQ;
extern double FREQ_A1;
extern double FREQ_LWA1;
extern int CODE_A1;
extern int CODE_HIGHST;
extern int ORDER_LWA1;

struct codePower {
    double size;
    int count;
};

void initMusic();

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

double codeNo2FreqRound(double code);
double codeNo2FreqFloor(double code);
double codeNo2FreqCeil(double code);
double codeNo2FreqLower(double code);
double codeNo2FreqHigher(double code);


#endif
