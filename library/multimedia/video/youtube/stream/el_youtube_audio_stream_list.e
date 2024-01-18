note
	description: "List of ${EL_YOUTUBE_AUDIO_STREAM} in descending order of **data_rate**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-26 17:23:57 GMT (Wednesday 26th April 2023)"
	revision: "9"

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