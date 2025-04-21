note
	description: "Implementation of ${EL_MANIFEST_SUBSTRING [STRING_32, CHARACTER_32]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-21 9:43:42 GMT (Monday 21st April 2025)"
	revision: "3"

class
	EL_MANIFEST_SUBSTRING_32

inherit
	EL_MANIFEST_SUBSTRING [STRING_32, CHARACTER_32]
		rename
			super as super_32
		undefine
			bit_count
		end

	EL_STRING_32_BIT_COUNTABLE [STRING_32]

create
	make_empty

convert
	string: {STRING_32}

feature {NONE} -- Implementation

	append_lines_to (str_32: STRING_32; line_list: EL_SPLIT_IMMUTABLE_STRING_8_LIST)
		do
			across line_list as list loop
				if str_32.count > 0 then
					str_32.append_character ('%N')
				end
				list.append_item_to_string_32 (str_32)
			end
		end

end