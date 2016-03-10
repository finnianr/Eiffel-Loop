note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_AUDIO_CLIP_SAVER_CONSTANTS

feature {NONE} -- Constants

	Num_digits_in_clip_no: INTEGER = 4
	
	Clip_no_base: INTEGER
			--
		note
			once_status: global
		once
			Result := (10.0 ^ Num_digits_in_clip_no.to_double ).rounded
		end
	
	Clip_base_name: STRING = "speech-audio_clip"
	
	Silent_clip_name: STRING
			-- 
		note
			once_status: global
		once
			Result := "silence"
		end
		

end
