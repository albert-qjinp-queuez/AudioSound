//
//  ASEng.h
//  audiosound
//
//  Created by qjinp on 6/7/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

#ifndef audiosound_ASEng_h
#define audiosound_ASEng_h

#include "portaudio.h"
#include "pa_mac_core.h"

typedef struct
{
    float left_phase;
    float right_phase;
}
paTestData;

extern paTestData *data2;

int patestCallback2( const void *inputBuffer, void *outputBuffer,
                          unsigned long framesPerBuffer,
                          const PaStreamCallbackTimeInfo* timeInfo,
                          PaStreamCallbackFlags statusFlags,
                          void *userData );

#endif
