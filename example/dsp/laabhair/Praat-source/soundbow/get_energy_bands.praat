# author: "Finnian Reilly"
﻿# copyright: "Copyright (c) 2001-2009 Finnian Reilly"
﻿# contact: "finnian at eiffel hyphen loop dot com"
﻿# license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
﻿# date: "8 May 2009"
﻿# revision: "0.1"

sample_file_path$ = "D:\Articulate!\Programming\eiffel\soundbow\praat-test\sound-samples\speech-audio_clip-0011.wav"

sample_name$ = "speech-audio_clip-0011"

num_octaves = 4
num_microtones_per_octave = 50
octave_base_freq = 110

microtone_interval_ratio = 10 ^ (log10 (2) / num_microtones_per_octave)

Read from file... 'sample_file_path$'

To Spectrum... fast
select Spectrum 'sample_name$'

for octave from 1 to num_octaves
	echo octave_base_freq = 'octave_base_freq'

	tone_frequency_lower = octave_base_freq
	for microtone to num_microtones_per_octave
		tone_frequency_upper = tone_frequency_lower * microtone_interval_ratio
		
		echo o'octave'_m'microtone' = Get band energy... 'tone_frequency_lower' 'tone_frequency_upper'
		
		o'octave'_m'microtone' = Get band energy... tone_frequency_lower tone_frequency_upper
		tone_frequency_lower = tone_frequency_upper
	endfor 
	octave_base_freq = octave_base_freq * 2
endfor

select all
Remove
