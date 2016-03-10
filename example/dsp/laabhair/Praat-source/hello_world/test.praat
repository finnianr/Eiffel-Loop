# author: "Finnian Reilly"
﻿# copyright: "Copyright (c) 2001-2009 Finnian Reilly"
﻿# contact: "finnian at eiffel hyphen loop dot com"
﻿# license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
﻿# date: "8 May 2009"
﻿# revision: "0.1"

 audio_file_path$ = "C:\DOCUME~1\ADMINI~1\LOCALS~1\Temp\speech-audio_clip-0001.wav"
 sample_count = 1000
 
           Read from file... 'audio_file_path$'
           sound$ = selected$ ("Sound")
 
           message$ = "Hello world! ('sound$'.wav)"
           sample_count = sample_count + 1
           intensity_db = Get intensity (dB)
 

	echo message$ = 'message$'
	echo sample_count = 'sample_count'
	echo intensity_db = 'intensity_db'
	echo 'newline$'

           select all
           Remove

          
