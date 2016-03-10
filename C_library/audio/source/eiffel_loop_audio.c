/*********************************************************************************

	Author: Finnian Reilly
	Part of the "Eiffel LOOP library".
	http://www.eiffel-loop.com

*********************************************************************************/
#include <windows.h>
#include "eiffel_loop_audio.h"

// Internal WaveOut API callback function.
volatile int buffers_played_count = 0;

void CALLBACK waveOutProc(HWAVEOUT hwo, UINT uMsg, DWORD dwInstance, DWORD dwParam1, DWORD dwParam2)

{
	switch (uMsg){
		case WOM_OPEN:
			buffers_played_count = 0;
			break;

		case WOM_DONE:
			buffers_played_count++;
			break;
	}

}

