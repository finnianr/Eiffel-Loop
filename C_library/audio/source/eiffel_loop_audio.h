/*********************************************************************************

	Author: Finnian Reilly
	Part of the "Eiffel LOOP library".
	http://www.eiffel-loop.com

*********************************************************************************/

#ifndef	__EIFFEL_LOOP_AUDIO_H
#define	__EIFFEL_LOOP_AUDIO_H

#include <eif_hector.h>

void CALLBACK waveOutProc (HWAVEOUT hwo, UINT uMsg, DWORD dwInstance, DWORD dwParam1, DWORD dwParam2);

volatile int buffers_played_count;

#endif
