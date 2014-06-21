//
//  ASEng.c
//  audiosound
//
//  Created by qjinp on 6/7/14.
//  Copyright (c) 2014 albert.q.park. All rights reserved.
//

//#include <stdio.h>
#include "ASEng.h"

paTestData *data2;

/* This routine will be called by the PortAudio engine when audio is needed.
 It may called at interrupt level on some machines so don't do anything
 that could mess up the system like calling malloc() or free().
 */
int patestCallback2( const void *inputBuffer, void *outputBuffer,
                          unsigned long framesPerBuffer,
                          const PaStreamCallbackTimeInfo* timeInfo,
                          PaStreamCallbackFlags statusFlags,
                          void *userData )
{
    /* Cast data passed through stream to our structure. */
    data2 = (paTestData*)userData;
    float *out = (float*)outputBuffer;
    unsigned int i;
    (void) inputBuffer; /* Prevent unused variable warning. */
    
    for( i=0; i<framesPerBuffer; i++ )
    {
        *out++ = data2->left_phase;  /* left */
        *out++ = data2->right_phase;  /* right */
        /* Generate simple sawtooth phaser that ranges between -1.0 and 1.0. */
        data2->left_phase += 0.01f;
        /* When signal reaches top, drop back down. */
        if( data2->left_phase >= 1.0f ) data2->left_phase -= 2.0f;
        /* higher pitch so we can distinguish left and right. */
        data2->right_phase += 0.03f;
        if( data2->right_phase >= 1.0f ) data2->right_phase -= 2.0f;
    }
    return 0;
}
