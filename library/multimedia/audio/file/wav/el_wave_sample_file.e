note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "2"

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
