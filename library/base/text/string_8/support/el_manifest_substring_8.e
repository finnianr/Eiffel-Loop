note
	description: "Implementation of ${EL_MANIFEST_SUBSTRING [STRING_8, CHARACTER_8]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-21 9:43:46 GMT (Monday 21st April 2025)"
	revision: "5"

class
	EL_MANIFEST_SUBSTRING_8

inherit
	EL_MANIFEST_SUBSTRING [STRING_8, CHARACTER_8]
		rename
			super as super_8
		undefine
			bit_count
		redefine
			append_string_8
		end

	EL_STRING_8_BIT_COUNTABLE [STRING_8]

create
	make_empty

convert
	string: {STRING_8}

feature {NONE} -- Implementation

	append_lines_to (str_8: STRING_8; line_list: EL_SPLIT_IMMUTABLE_STRING_8_LIST)
		do
			across line_list as list loop
				if str_8.count > 0 then
					str_8.append_character ('%N')
				end
				list.append_item_to_string_8 (str_8)
			end
		end

	append_string_8 (target: STRING_8; str_8: READABLE_STRING_8)
		do
			target.append (str_8)
		end

end