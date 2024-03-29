note
	description: "Pyxis attribute parser with deferred implementation of parse events"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-19 11:16:36 GMT (Saturday 19th November 2022)"
	revision: "4"

class
	PYXIS_ATTRIBUTE_TEST_PARSER

inherit
	EL_PYXIS_ATTRIBUTE_PARSER
		rename
			make_default as make
		redefine
			make, reset, default_source_text
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			create table.make (11)
			create last_name.make_empty
			Precursor
		end

feature -- Element change

	reset
			--
		do
			Precursor
			table.wipe_out
		end

feature -- Access

	last_name: STRING

	table: HASH_TABLE [STRING, STRING]

feature {NONE} -- Parse events

	on_name (start_index, end_index: INTEGER)
			--
		do
			last_name := source_text.substring (start_index, end_index)
		end

	on_quoted_value (content: STRING_GENERAL)
			--
		do
			if attached {STRING_8} content as str_8 then
				table [last_name] := str_8
			end
		end

	on_value (start_index, end_index: INTEGER)
		--
		do
			table [last_name] := source_text.substring (start_index, end_index)
		end

feature {NONE} -- Implementation

	default_source_text: STRING_8
		do
			Result := Empty_string_8
		end

end