note
	description: "Forces shared string data into an instance of [$source IMMUTABLE_STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-06 11:16:31 GMT (Monday 6th March 2023)"
	revision: "1"

class
	EL_IMMUTABLE_8_MANAGER

inherit
	EL_IMMUTABLE_STRING_MANAGER [CHARACTER_8, IMMUTABLE_STRING_8]

	EL_SHARED_STRING_8_CURSOR

feature {NONE} -- Contract Support

	same_area_items (a_area: SPECIAL [CHARACTER_8]; offset, a_count: INTEGER): BOOLEAN
		do
			if attached cursor_8 (item) as c then
				Result := c.area.same_items (a_area, offset, c.area_first_index, a_count)
			end
		end

feature {NONE} -- Constants

	Shared_field_table: SPECIAL [INTEGER]
		once
			Result := new_field_table
		end

end