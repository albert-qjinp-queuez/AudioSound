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
double CodeNo2FreqRound(int code){
    double rt12 = cbrt(sqrt(sqrt(2.0)));
    return exp(log(rt12)*(double)code)*440 ;
    
}
//getting lower bound freq of the code
double CodeNo2FreqFloor(int code){
    double rt12 = cbrt(sqrt(sqrt(2.0)));
    return exp(log(rt12)*((double)code - 0.5))*440 ;
}
//getting upper bound freq of the code
double CodeNo2FreqCeil(int code){
    double rt12 = cbrt(sqrt(sqrt(2.0)));
    return exp(log(rt12)*((double)code + 0.5))*440 ;
}