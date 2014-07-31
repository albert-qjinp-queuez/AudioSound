//
//  Music.c
//  audiosound
//
//  Created by qjinp on 7/11/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

//#include <stdio.h>
#include <math.h>
#include "Music.h"

char* cStrCode[] = {"A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#"};

long int BUF_SIZE = 32768;
long int SAMPLE_RATE = 8192;
long int SAMPLE_SIZE = 256;
double BASE_FREQ = 440;
double FREQ_A1 = 55;
double FREQ_LWA1;
int CODE_A1;
int CODE_HIGHST;
int ORDER_LWA1;

void initMusic(){
    CODE_A1 = freq2CodeNo(55.0);
    FREQ_LWA1 = codeNo2FreqCeil(CODE_A1);
    ORDER_LWA1 = freq2order(FREQ_LWA1);
    CODE_HIGHST = order2CodeNo((int)BUF_SIZE);
}


int codeNo2OrderRound(int codeNo){
    return freq2order(codeNo2FreqRound(codeNo));
}
int codeNo2OrderLower(int codeNo){
    return freq2order(codeNo2FreqLower(codeNo));
}
int codeNo2OrderHigher(int codeNo){
    return freq2order(codeNo2FreqHigher(codeNo));
}

int order2CodeNo(int order){
    return freq2CodeNo(order2freq(order));
}

double order2freq(int num){
    return num*SAMPLE_RATE /2.0/BUF_SIZE;
}
int freq2order(double freq){
    return freq * 2.0 * BUF_SIZE/ SAMPLE_RATE;
}

int getCodeNo(int oct, int scale){
    return oct*12 + scale;
}

int getScale(int code){
    int mod = code%12;
    if (mod < 0) {
        mod += 12;
    }
    return mod;
}
int getOct(int code){
    return code/12;
}

int freq2CodeNo(double freq){
    double rt12 = cbrt(sqrt(sqrt(2.0)));
    double theCode = (freq/(double)440/rt12);
    double a = log(theCode)/log(rt12);
    return round(a)+1;
}


//getting exact freq of the code
double codeNo2FreqRound(double code){
    double rt12 = cbrt(sqrt(sqrt(2.0)));
    return exp(log(rt12)*code)*440 ;
}

//getting lower bound freq of the code
double codeNo2FreqFloor(double code){
    return codeNo2FreqRound(code - 0.5);
}
//getting upper bound freq of the code
double codeNo2FreqCeil(double code){
    return codeNo2FreqRound(code + 0.5);
}
//getting slightly lower freq of the code
double codeNo2FreqLower(double code){
    return codeNo2FreqRound(code - 1.0/3.0);
}
//getting slightly upper freq of the code
double codeNo2FreqHigher(double code){
    return codeNo2FreqRound(code + 1.0/3.0);
}


