note
	description: "List of ${EL_YOUTUBE_AUDIO_STREAM} in descending order of **data_rate**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "10"

class
	EL_YOUTUBE_AUDIO_STREAM_LIST

inherit
	EL_YOUTUBE_STREAM_LIST
		rename
			type as Audio_type
		end

create
	make

feature {NONE} -- Implementation

	display_extra (name_count: INTEGER)
		do
			do_nothing
		end

	new_stream (info_line: ZSTRING): EL_YOUTUBE_AUDIO_STREAM
		do
			create Result.make (info_line)
		end

end