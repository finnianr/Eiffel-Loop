note
	description: "Forces shared string data into an instance of ${IMMUTABLE_STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-20 16:02:17 GMT (Sunday 20th April 2025)"
	revision: "12"

class
	EL_IMMUTABLE_8_MANAGER

inherit
	EL_IMMUTABLE_STRING_MANAGER [CHARACTER_8, READABLE_STRING_8, IMMUTABLE_STRING_8]
		undefine
			bit_count
		end

	EL_STRING_8_BIT_COUNTABLE [IMMUTABLE_STRING_8]

feature {NONE} -- Initialization

	initialize
		do
		end

feature -- Status query

	item_has_left_padding: BOOLEAN
		do
			Result := item.count > 0 and then item [1].is_space
		end

	item_has_right_padding: BOOLEAN
		do
			Result := item.count > 0 and then item [item.count].is_space
		end

feature {NONE} -- Contract Support

	same_area_items (a_area: SPECIAL [CHARACTER_8]; offset, a_count: INTEGER): BOOLEAN
		local
			index_lower: INTEGER
		do
			if attached Character_area_8.get_lower (item, $index_lower) as l_area then
				Result := l_area.same_items (a_area, offset, index_lower, a_count)
			end
		end

feature {NONE} -- Implementation

	is_space (a_area: SPECIAL [CHARACTER_8]; i: INTEGER): BOOLEAN
		do
			Result := a_area [i].is_space
		end

	new_immutable_substring (str: IMMUTABLE_STRING_8; start_index, end_index: INTEGER): IMMUTABLE_STRING_8
		do
			Result := str.shared_substring (start_index, end_index)
		end

	string_area (str: READABLE_STRING_8): SPECIAL [CHARACTER_8]
		do
			if attached {STRING_8} str as str_8 then
				Result := str_8.area
			else
				Result := str.as_string_8.area
			end
		end

feature {NONE} -- Constants

	Shared_field_table: SPECIAL [INTEGER]
		once
			Result := new_field_table
		end

end