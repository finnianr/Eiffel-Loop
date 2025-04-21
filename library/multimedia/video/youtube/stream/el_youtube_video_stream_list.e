note
	description: "List of ${EL_YOUTUBE_VIDEO_STREAM} in descending order of **data_rate**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-21 10:13:06 GMT (Monday 21st April 2025)"
	revision: "11"

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

	EL_STRING_GENERAL_ROUTINES_I

create
	make

feature {NONE} -- Implementation

	display_extra (name_count: INTEGER)
		local
			option: STRING
		do
			option := Format.padded_integer (count + 1, 2) + ". Audio track only"
			lio.put_labeled_string (option + Shared_super_8.filled (' ', name_count - option.count), "   0p, (no video)")
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