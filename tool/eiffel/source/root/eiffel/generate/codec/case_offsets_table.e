note
	description: "Table of case-change offsets for a character code interval"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 17:07:40 GMT (Sunday 22nd September 2024)"
	revision: "3"

class
	CASE_OFFSETS_TABLE

inherit
	EL_HASH_TABLE [CODE_INTERVAL_LIST, NATURAL]
		rename
			extend as extend_table,
			make as make_sized
		end

create
	make

feature {NONE} -- Initialization

	make (a_name: STRING)
		do
			name := a_name
			make_sized (11)
		end

feature -- Access

	name: STRING

feature -- Conversion

	case_set_string: STRING
		do
			create Result.make (80)
			across to_string_table as case_set loop
				if case_set.cursor_index > 1 then
					Result.append (", ")
				end
				Result.append (case_set.item)
			end
		end

	to_string_table: HASH_TABLE [STRING, INTEGER_REF]
			-- Eg. {32: "97..122, 224..246, 248..254"}
		do
			create Result.make (count)
			across Current as table loop
				Result [table.key.to_integer_32.to_reference] := table.item.to_string
			end
		end

feature -- Element change

	extend (c1, c2: CHARACTER)
		local
			interval_list: CODE_INTERVAL_LIST; offset: NATURAL
		do
			if c1 < c2 then
				offset := c2.natural_32_code - c1.natural_32_code
			elseif c1 > c2 then
				offset := c1.natural_32_code - c2.natural_32_code
			end
			if offset > 0 then
				if has_key (offset) then
					interval_list := found_item
				else
					create interval_list.make (5)
					extend_table (interval_list, offset)
				end
				interval_list.extend_upper (c1.code)
			end
		end

end