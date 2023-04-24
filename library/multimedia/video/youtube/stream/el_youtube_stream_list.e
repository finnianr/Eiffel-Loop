note
	description: "List of [$source EL_YOUTUBE_STREAM] in descending order of **data_rate**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-24 13:31:15 GMT (Monday 24th April 2023)"
	revision: "7"

class
	EL_YOUTUBE_STREAM_LIST

inherit
	EL_ARRAYED_LIST [EL_YOUTUBE_STREAM]
		rename
			make as make_list,
			fill as fill_list,
			item as selected
		export
			{NONE} all
			{ANY} count, valid_index, selected, off
		end

	EL_MODULE_LIO

	EL_YOUTUBE_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_type: STRING; maximum_count: INTEGER)
		do
			make_list (maximum_count)
			type := a_type
			selector := a_type + " only"
		end

feature -- Access

	download: detachable EL_YOUTUBE_STREAM_DOWNLOAD
		-- user download choice

	type: STRING
		-- "audio" OR "video"

feature -- Element change

	fill (line_list: EL_ZSTRING_LIST)
		local
			stream: EL_YOUTUBE_STREAM; stream_map: EL_ARRAYED_MAP_LIST [INTEGER, EL_YOUTUBE_STREAM]
			line: ZSTRING
		do
			create stream_map.make (capacity * 2)
			across line_list as list loop
				line := list.item
				if line.has_substring (selector) then
					if type = Audio then
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
			across stream_map as map until full loop
				map.value.set_index (map.cursor_index)
				extend (map.value)
			end
		end

feature -- Basic operations

	set_user_choice (url: ZSTRING)
		-- get user `download' selection
		local
			prompt_template, response_template, invalid_response: ZSTRING
			menu_input: EL_USER_INPUT_VALUE [INTEGER]; i: INTEGER
		do
			display
			prompt_template := "Enter %S number"; response_template := "Number %S is not a valid %S stream"
			invalid_response := response_template #$ ['%S', type]
			create menu_input.make_valid (prompt_template #$ [type], invalid_response, agent valid_input)
			i := menu_input.value
			if valid_index (i) then
				go_i_th (i)
				create download.make (url, selected)
			else
				download := Void
			end
		end

feature {NONE} -- Implementation

	display
		local
			s: EL_STRING_8_ROUTINES; padding: STRING
		do
			lio.put_line (type.as_upper + " STREAMS")
			lio.put_new_line
			across Current as list loop
				if list.is_first then
					padding := s.n_character_string (' ', list.item.name.count - 8)
					lio.put_labeled_string (" 0. Quit" + padding, s.n_character_string ('-', 50))
					lio.put_new_line
				end
				lio.put_labeled_string (list.item.name, list.item.description)
				lio.put_new_line
			end
			lio.put_new_line
		end

	valid_input (i: INTEGER): BOOLEAN
		do
			Result := i = 0 or else valid_index (i)
		end

feature {NONE} -- Internal attributes

	selector: STRING
end