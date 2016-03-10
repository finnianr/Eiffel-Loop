# author: "Finnian Reilly"
﻿# copyright: "Copyright (c) 2001-2009 Finnian Reilly"
﻿# contact: "finnian at eiffel hyphen loop dot com"
﻿# license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
﻿# date: "8 May 2009"
﻿# revision: "0.1"

laabhair_path$ = environment$ ("LAABHAIR")

#temp$ = environment$ ("TEMP")
#audio_file_path$ = "'temp$'\speech-audio_clip-0002.wav"

#sound_name$ = "speech-audio_clip-0001"

sample_count = 1000

for i from 1 to 5
	audio_file_path$ = "'laabhair_path$'\audio-test-samples\speech-audio_clip-000'i'.wav"

	# Call script
include hello_world.praat
	#include hello_world_1.praat
	
	# Out put results
	echo message$ = 'message$'
	echo sample_count = 'sample_count'
	echo intensity_db = 'intensity_db'
	echo 'newline$'
	
endfor
