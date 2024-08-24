note
	description: "[
		Table of ${EL_ZSTRING} strings with keys of type ${STRING_8} and createable from
		parsed general text with format
		
			key_1:
				Value One Line 1
				Value One Line 2
				..
			key_2:
				Value Two
				etc
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-24 10:43:23 GMT (Saturday 24th August 2024)"
	revision: "19"

class
	EL_ZSTRING_TABLE

inherit
	EL_HASH_TABLE [ZSTRING, IMMUTABLE_STRING_8]
		rename
			make as make_from_array
		end

	EL_STRING_GENERAL_ROUTINES

	EL_CHARACTER_8_CONSTANTS

create
	make, make_size, make_from_array, make_from_table

feature {NONE} -- Initialization

	make (table_text: READABLE_STRING_GENERAL)
		local
			table: EL_IMMUTABLE_UTF_8_TABLE
		do
			create table.make_field_map (table_text)
			make_from_table (table)
		end

	make_from_table (table: EL_IMMUTABLE_UTF_8_TABLE)
		do
			make_size (table.count)
			from table.start until table.after loop
				extend (table.item_for_iteration, table.key_for_iteration)
				table.forth
			end
		end

feature -- Access

	name_list: EL_STRING_8_LIST
		do
			create Result.make_from_general (current_keys)
		end
end