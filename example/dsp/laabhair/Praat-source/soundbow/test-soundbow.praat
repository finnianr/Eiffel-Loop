# author: "Finnian Reilly"
﻿# copyright: "Copyright (c) 2001-2009 Finnian Reilly"
﻿# contact: "finnian at eiffel hyphen loop dot com"
﻿# license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
﻿# date: "8 May 2009"
﻿# revision: "0.1"

laabhair_path$ = environment$ ("LAABHAIRT")

# Initialize script variables
audio_file_path$ = "'laabhair_path$'\audio-test-samples\speech-audio_clip-0001.wav"

sound_name$ = "speech-audio_clip-0001"

num_octaves = 4
num_microtones_per_octave = 50
octave_base_freq = 110

microtone_interval_ratio = 10 ^ (log10 (2) / num_microtones_per_octave)

# Call script
include soundbow.praat

echo o4_m50 = 'o4_m50'
