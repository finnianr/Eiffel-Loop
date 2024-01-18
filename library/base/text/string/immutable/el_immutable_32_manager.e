note
	description: "Forces shared string data into an instance of ${IMMUTABLE_STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-27 12:54:26 GMT (Wednesday 27th December 2023)"
	revision: "7"

class
	EL_IMMUTABLE_32_MANAGER

inherit
	EL_IMMUTABLE_STRING_MANAGER [CHARACTER_32, READABLE_STRING_32, IMMUTABLE_STRING_32]
		rename
			cursor as cursor_32
		undefine
			bit_count
		end

	EL_STRING_32_BIT_COUNTABLE [IMMUTABLE_STRING_32]

	EL_SHARED_STRING_32_CURSOR

	CHARACTER_PROPERTY
		rename
			make as make_property,
			is_space as is_space_character
		export
			{NONE} all
		undefine
			default_create
		end

feature -- Status query

	item_has_left_padding: BOOLEAN
		do
			Result := item.count > 0 and then is_space_character (item [1])
		end

	item_has_right_padding: BOOLEAN
		do
			Result := item.count > 0 and then is_space_character (item [item.count])
		end

feature {NONE} -- Contract Support

	same_area_items (a_area: SPECIAL [CHARACTER_32]; offset, a_count: INTEGER): BOOLEAN
		do
			if attached cursor_32 (item) as c then
				Result := c.area.same_items (a_area, offset, c.area_first_index, a_count)
			end
		end

feature {NONE} -- Implementation

	is_space (a_area: SPECIAL [CHARACTER_32]; i: INTEGER): BOOLEAN
		do
			Result := is_space_character (a_area [i]) -- workaround for finalization bug
		end

	string_area (str: READABLE_STRING_32): SPECIAL [CHARACTER_32]
		do
			if attached {STRING_32} str as str_32 then
				Result := str_32.area
			else
				Result := str.as_string_32.area
			end
		end

feature {NONE} -- Constants

	Shared_field_table: SPECIAL [INTEGER]
		once
			Result := new_field_table
		end

end