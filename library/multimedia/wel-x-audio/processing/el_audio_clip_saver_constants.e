note
	description: "Audio clip saver constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-31 6:34:21 GMT (Wednesday 31st July 2019)"
	revision: "4"

class
	EL_AUDIO_CLIP_SAVER_CONSTANTS

feature {NONE} -- Constants

	Num_digits_in_clip_no: INTEGER = 4

	Clip_no_base: INTEGER
			--
		once ("PROCESS")
			Result := (10.0 ^ Num_digits_in_clip_no.to_double ).rounded
		end

	Clip_base_name: ZSTRING
		once
			Result := "speech-audio_clip"
		end

	Silent_clip_name: STRING
			--
		once ("PROCESS")
			Result := "silence"
		end


end
