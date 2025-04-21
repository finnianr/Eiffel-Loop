note
	description: "Implementation of ${EL_MANIFEST_SUBSTRING [ZSTRING, CHARACTER_32]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-21 9:43:38 GMT (Monday 21st April 2025)"
	revision: "3"

class
	EL_MANIFEST_SUB_ZSTRING

inherit
	EL_MANIFEST_SUBSTRING [ZSTRING, CHARACTER_32]
		rename
			super as super_z
		undefine
			bit_count
		end

	EL_STRING_32_BIT_COUNTABLE [ZSTRING]

create
	make_empty

convert
	string: {ZSTRING}

feature {NONE} -- Implementation

	append_lines_to (a_str: ZSTRING; line_list: EL_SPLIT_IMMUTABLE_STRING_8_LIST)
		do
			across line_list as list loop
				if a_str.count > 0 then
					a_str.append_character ('%N')
				end
				list.append_item_to (a_str)
			end
		end

end