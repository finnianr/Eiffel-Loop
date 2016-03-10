# author: "Finnian Reilly"
﻿# copyright: "Copyright (c) 2001-2009 Finnian Reilly"
﻿# contact: "finnian at eiffel hyphen loop dot com"
﻿# license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
﻿# date: "8 May 2009"
﻿# revision: "0.1"

Read from file... 'audio_file_path$'

To Spectrum... (fft)
select Spectrum 'sound_name$'

for octave from 1 to num_octaves
	tone_frequency_lower = octave_base_freq

	for microtone from 1 to num_microtones_per_octave
		tone_frequency_upper = tone_frequency_lower * microtone_interval_ratio
		o'octave'_m'microtone' = Get band energy... tone_frequency_lower tone_frequency_upper
		tone_frequency_lower = tone_frequency_upper
	endfor 
	octave_base_freq = octave_base_freq * 2
endfor

# Light up end of 4th octave as a test
o4_m46 = 0.5666666E-3
o4_m48 = 0.5666666E-3
o4_m50 = 0.5666666E-3

select all
Remove
