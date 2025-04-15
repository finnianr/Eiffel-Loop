note
	description: "Pyxis attribute parser with deferred implementation of parse events"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-15 15:14:10 GMT (Tuesday 15th April 2025)"
	revision: "5"

class
	PYXIS_ATTRIBUTE_TEST_PARSER

inherit
	EL_PYXIS_ATTRIBUTE_PARSER
		rename
			make_default as make
		redefine
			make, reset
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

	last_name: STRING_8

	table: HASH_TABLE [STRING, STRING_8]

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

end