note
	description: "List of [$source EL_YOUTUBE_STREAM] in descending order of **data_rate**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-26 13:43:51 GMT (Wednesday 26th April 2023)"
	revision: "8"

deferred class
	EL_YOUTUBE_STREAM_LIST

inherit
	EL_ARRAYED_LIST [EL_YOUTUBE_STREAM]
		rename
			fill as fill_list,
			item as selected
		export
			{NONE} all
			{ANY} count, valid_index, selected, off
		end

	EL_MODULE_LIO

	EL_YOUTUBE_CONSTANTS

	EL_STRING_8_CONSTANTS

feature -- Access

	type: STRING
		-- "audio" OR "video"
		deferred
		end

	selected_index: INTEGER

feature -- Element change

	fill (line_list: EL_ZSTRING_LIST)
		local
			stream: like new_stream; stream_map: EL_ARRAYED_MAP_LIST [INTEGER, like new_stream]
			line: ZSTRING; selector: STRING
		do
			selector := type + " only"

			create stream_map.make (capacity * 2)
			across line_list as list loop
				line := list.item
				if line.has_substring (selector) then
					stream := new_stream (line)
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

	get_user_choice (url: ZSTRING; download_list: EL_YOUTUBE_STREAM_DOWNLOAD_LIST)
		-- get user `download' selection
		local
			prompt_template, response_template, invalid_response: ZSTRING
			menu_input: EL_USER_INPUT_VALUE [INTEGER]
		do
			display_menu

			prompt_template := "Select %S option"; response_template := "Number %S is not a valid %S option"
			invalid_response := response_template #$ ['%S', type]
			create menu_input.make_valid (prompt_template #$ [type], invalid_response, agent valid_input)
			selected_index := menu_input.value
			if valid_index (selected_index) then
				go_i_th (selected_index)
				download_list.extend (create {EL_YOUTUBE_STREAM_DOWNLOAD}.make (url, selected))
			end
		end

feature {NONE} -- Implementation

	display_menu
		local
			s: EL_STRING_8_ROUTINES; name_count: INTEGER
		do
			lio.put_line (type.as_upper + " STREAMS")
			lio.put_new_line
			across Current as list loop
				if list.is_first then
					name_count := list.item.name.count
					lio.put_labeled_string (" 0. Quit" + s.n_character_string (' ', name_count - 8), Empty_string_8)
					lio.put_new_line
				end
				lio.put_labeled_string (list.item.name, list.item.description)
				lio.put_new_line
			end
			display_extra (name_count)
			lio.put_new_line
		end

	valid_input (i: INTEGER): BOOLEAN
		do
			Result := i = 0 or else valid_index (i)
		end

feature {NONE} -- Deferred

	new_stream (info_line: ZSTRING): EL_YOUTUBE_STREAM
		deferred
		end

	display_extra (name_count: INTEGER)
		deferred
		end

end