note
	description: "Table of field indices by name"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-20 9:58:03 GMT (Monday 20th March 2023)"
	revision: "2"

class
	EL_FIELD_INDEX_TABLE

inherit
	HASH_TABLE [INTEGER, STRING]
		rename
			make as make_table
		end

create
	make

feature {NONE} -- Initialization

	make (reflected: REFLECTED_REFERENCE_OBJECT; field_names: STRING)
		local
			field_list: EL_SPLIT_STRING_8_LIST; i, field_count: INTEGER
			name: STRING
		do
			create field_list.make_adjusted (field_names, ',', {EL_SIDE}.Left)
			make_table (field_list.count)
			field_count := reflected.field_count
			from i := 1 until i > field_count loop
				name := reflected.field_name (i)
				if field_list.has (name) then
					extend (i, name)
				end
				i := i + 1
			end
			is_valid := count = field_list.count
		ensure
			valid_names: is_valid
		end

feature -- Status query

	is_valid: BOOLEAN

end