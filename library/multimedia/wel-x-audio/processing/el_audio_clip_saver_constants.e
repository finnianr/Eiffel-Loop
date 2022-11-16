note
	description: "Audio clip saver constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

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