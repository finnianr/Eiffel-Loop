note
	description: "List of [$source EL_YOUTUBE_STREAM] in descending order of **data_rate**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-23 18:16:46 GMT (Sunday 23rd April 2023)"
	revision: "6"

class
	EL_YOUTUBE_STREAM_LIST

inherit
	EL_ARRAYED_LIST [EL_YOUTUBE_STREAM]
		rename
			fill as fill_list
		export
			{NONE} all
			{ANY} count, item, i_th, valid_index
		end

	EL_MODULE_LIO

	EL_YOUTUBE_CONSTANTS

create
	make

feature -- Element change

	fill (line_list: EL_ZSTRING_LIST; selector: STRING; maximum_count: INTEGER)
		local
			stream: EL_YOUTUBE_STREAM; stream_map: EL_ARRAYED_MAP_LIST [INTEGER, EL_YOUTUBE_STREAM]
			line: ZSTRING
		do
			create stream_map.make (20)
			across line_list as list loop
				line := list.item
				if line.has_substring (selector) then
					if selector = Audio_only then
						create {EL_YOUTUBE_AUDIO_STREAM} stream.make (line)
					else
						create {EL_YOUTUBE_VIDEO_STREAM} stream.make (line)
					end
					if not stream.has_code_qualifier then
						stream_map.extend (stream.data_rate, stream)
					end
				end
			end
			stream_map.sort_by_key (False)
			across stream_map as map until map.cursor_index > maximum_count loop
				map.value.set_index (map.cursor_index)
				extend (map.value)
			end
		end

end