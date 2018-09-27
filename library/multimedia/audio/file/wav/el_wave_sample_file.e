note
	description: "Wave sample file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_WAVE_SAMPLE_FILE [S -> EL_AUDIO_PCM_SAMPLE create make end]

inherit
	EL_WAVE_SAMPLE_FILE_ABS
		
create		
	make
	
feature {NONE} -- Initialization

	create_sample: EL_AUDIO_PCM_SAMPLE
			-- 
		do
			Result := create {S}.make 
		end

end