note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

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
