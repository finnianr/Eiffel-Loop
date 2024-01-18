note
	description: "List of ${EL_YOUTUBE_VIDEO_STREAM} in descending order of **data_rate**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 15:40:28 GMT (Thursday 17th August 2023)"
	revision: "9"

class
	EL_YOUTUBE_VIDEO_STREAM_LIST

inherit
	EL_YOUTUBE_STREAM_LIST
		rename
			type as Video_type
		redefine
			valid_input
		end

	EL_MODULE_FORMAT

create
	make

feature {NONE} -- Implementation

	display_extra (name_count: INTEGER)
		local
			s: EL_STRING_8_ROUTINES; option: STRING
		do
			option := Format.padded_integer (count + 1, 2) + ". Audio track only"
			lio.put_labeled_string (option + s.n_character_string (' ', name_count - option.count), "   0p, (no video)")
			lio.put_new_line
		end

	new_stream (info_line: ZSTRING): EL_YOUTUBE_VIDEO_STREAM
		do
			create Result.make (info_line)
		end

	valid_input (i: INTEGER): BOOLEAN
		do
			Result := i = count + 1 or else valid_index (i)
		end

end