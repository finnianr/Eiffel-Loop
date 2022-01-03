note
	description: "Youtube stream selector"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:51:51 GMT (Monday 3rd January 2022)"
	revision: "2"

class
	EL_YOUTUBE_STREAM_SELECTOR

inherit
	ANY

	EL_YOUTUBE_CONSTANTS

	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

create
	make

feature {NONE} -- Initialization

	make (a_type: STRING; a_stream_table: like stream_table)
		require
			valid_type: Stream_predicate_table.has (a_type)
		do
			type := a_type; stream_table := a_stream_table
			included := Stream_predicate_table.item (a_type)
		end

feature -- Access

	code: NATURAL

	download (output_dir: DIR_PATH; title: ZSTRING): EL_YOUTUBE_STREAM_DOWNLOAD
		require
			valid_code: is_valid
		do
			if stream_table.has_key (code) then
				create Result.make (stream_table.found_item, output_dir, title)
			else
				create Result.make_default
			end
		end

feature -- Status query

	is_valid: BOOLEAN
		do
			Result := stream_table.has (code)
		end

feature -- Basic operations

	get_code
		-- get user `code' selection
		local
			l_title, prompt_template: ZSTRING
		do
			l_title := type; l_title.append_string_general (" STREAMS")
			prompt_template := "Enter %S code"
			from code := 0 until stream_table.has_key (code) and then included (stream_table.found_item) loop
				display (l_title)
				code := User_input.natural (prompt_template #$ [type.as_lower])
				lio.put_new_line
			end
		end

feature {NONE} -- Implementation

	display (a_title: ZSTRING)
		do
			lio.put_line (a_title)
			across stream_table as stream loop
				if included (stream.item) then
					lio.put_line (stream.item.description)
				end
			end
			lio.put_new_line
		end

feature {NONE} -- Internal attributes

	included: PREDICATE [EL_YOUTUBE_STREAM]

	stream_table: EL_YOUTUBE_STREAM_TABLE

	type: STRING
end
