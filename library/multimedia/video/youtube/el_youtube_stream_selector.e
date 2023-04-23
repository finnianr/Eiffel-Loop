note
	description: "Youtube stream selector"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-23 18:20:53 GMT (Sunday 23rd April 2023)"
	revision: "7"

class
	EL_YOUTUBE_STREAM_SELECTOR

inherit
	ANY

	EL_YOUTUBE_CONSTANTS

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make (a_type: STRING; a_stream_list: like stream_list)
		do
			type := a_type; stream_list := a_stream_list
		end

feature -- Access

	index: INTEGER
		-- selected stream index

	download (title, url: ZSTRING; output_dir: DIR_PATH): EL_YOUTUBE_STREAM_DOWNLOAD
		require
			valid_code: is_valid
		do
			if stream_list.valid_index (index) then
				create Result.make (title, url, stream_list [index], output_dir)
			else
				create Result.make_default
			end
		end

feature -- Status query

	is_valid: BOOLEAN
		do
			Result := stream_list.valid_index (index)
		end

feature -- Basic operations

	get_stream_index
		-- get user `index' selection
		local
			prompt_template, response_template, invalid_response: ZSTRING
			menu_input: EL_USER_INPUT_VALUE [INTEGER]
		do
			display (type + " STREAMS")
			prompt_template := "Enter %S number"; response_template := "Number %S is not a valid %S stream"
			invalid_response := response_template #$ ['%S', type.as_lower]
			create menu_input.make_valid (prompt_template #$ [type.as_lower], invalid_response, agent stream_list.valid_index)
			index := menu_input.value
		end

feature {NONE} -- Implementation

	display (a_title: ZSTRING)
		do
			lio.put_line (a_title)
			lio.put_new_line
			across stream_list as list loop
				lio.put_labeled_string (list.item.name, list.item.description)
				lio.put_new_line
			end
			lio.put_new_line
		end

feature {NONE} -- Internal attributes

	stream_list: EL_YOUTUBE_STREAM_LIST

	type: STRING
end