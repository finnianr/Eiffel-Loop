note
	description: "Youtube stream selector"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-04 14:40:52 GMT (Tuesday 4th October 2022)"
	revision: "3"

class
	EL_YOUTUBE_STREAM_SELECTOR

inherit
	ANY

	EL_YOUTUBE_CONSTANTS

	EL_MODULE_LIO

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
			l_title, prompt_template, response_template, invalid_response: ZSTRING
			code_input: EL_USER_INPUT_VALUE [NATURAL]
		do
			display (type + " STREAMS")
			prompt_template := "Enter %S code"; response_template := "Code %S is not a valid %S stream"
			invalid_response := response_template #$ ['%S', type.as_lower]
			create code_input.make_valid (prompt_template #$ [type.as_lower], invalid_response, agent valid_stream)
			code := code_input.value
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

	valid_stream (a_code: NATURAL): BOOLEAN
		do
			Result := stream_table.has_key (a_code) and then included (stream_table.found_item)
		end

feature {NONE} -- Internal attributes

	included: PREDICATE [EL_YOUTUBE_STREAM]

	stream_table: EL_YOUTUBE_STREAM_TABLE

	type: STRING
end