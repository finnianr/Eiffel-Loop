note
	description: "[
		Table of ${EL_ZSTRING} strings with immutable keys of type ${IMMUTABLE_STRING_8}
		and createable from parsed general text with format
		
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
	date: "2024-09-22 13:52:41 GMT (Sunday 22nd September 2024)"
	revision: "23"

class
	EL_ZSTRING_TABLE

inherit
	EL_HASH_TABLE [ZSTRING, IMMUTABLE_STRING_8]
		rename
			make as make_sized,
			make_assignments as make_from_tuples
		end

	EL_STRING_GENERAL_ROUTINES

	EL_CHARACTER_8_CONSTANTS

	EL_SHARED_IMMUTABLE_8_MANAGER

create
	make, make_assignments, make_indented_eiffel, make_sized, make_from_table

convert
	make_indented_eiffel ({STRING_8, STRING_32, ZSTRING})

feature {NONE} -- Initialization

	make_assignments (assignment_array: ARRAY [TUPLE [key: READABLE_STRING_8; value: ZSTRING]])
		do
			make_equal (assignment_array.count)
			across assignment_array as array loop
				if attached array.item as tuple then
					extend (tuple.value, Immutable_8.as_shared (tuple.key))
				end
			end
		end

	make_indented_eiffel (indented_table_text: READABLE_STRING_GENERAL)
		-- make from indented text with Eiffel identifier field names
		do
			make ({EL_TABLE_FORMAT}.Indented_eiffel, indented_table_text)
		end

	make (format: NATURAL_8; indented_table_text: READABLE_STRING_GENERAL)
		-- make from `indented_table_text' with fields named with indented format `format'
		require
			valid_format: Table_format.valid_indented (format)
		local
			table: EL_IMMUTABLE_UTF_8_TABLE
		do
			create table.make (format, indented_table_text)
			make_from_table (table)
		end

	make_from_table (table: EL_IMMUTABLE_UTF_8_TABLE)
		do
			make_equal (table.count)
			from table.start until table.after loop
				extend (table.item_for_iteration, table.key_for_iteration)
				table.forth
			end
		end

feature -- Access

	name_list: EL_STRING_8_LIST
		do
			create Result.make_from_general (key_list)
		end

feature -- Contract Support

	table_format: EL_TABLE_FORMAT
		do
			create Result
		end
end