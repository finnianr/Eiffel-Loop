note
	description: "Table of case-change offsets for a character code interval"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-16 11:25:48 GMT (Thursday 16th March 2023)"
	revision: "1"

class
	CASE_OFFSETS_TABLE

inherit
	HASH_TABLE [CODE_INTERVAL_LIST, NATURAL]
		rename
			extend as extend_table
		end

create
	make

feature -- Conversion

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