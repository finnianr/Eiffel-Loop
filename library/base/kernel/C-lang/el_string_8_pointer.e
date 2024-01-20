note
	description: "[
		Manages ${SPECIAL [CHARACTER]} data from a string conforming to ${READABLE_STRING_8}
	]"
	notes: "[
		The character data is frozen in place and cannot be moved by garbage collector until such
		times as the object is disposed.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "3"

class
	EL_STRING_8_POINTER

inherit
	MANAGED_POINTER
		rename
			make as make_size
		redefine
			dispose
		end

	EL_EIFFEL_C_API undefine copy, is_equal end

	STRING_HANDLER undefine copy, is_equal end

	EL_SHARED_STRING_8_CURSOR

create
	make

convert
	make ({STRING, IMMUTABLE_STRING_8, EL_UTF_8_STRING})

feature {NONE} -- Initialization

	make (string: READABLE_STRING_8)
		do
			if attached cursor_8 (string) as c then
				area := c.area
				-- Prevent garbage collector from moving or collecting `area'
				adopted_area := eif_adopt (area)
				area_first_index := c.area_first_index
				share_from_pointer (area.base_address + area_first_index, string.count)
			end
		end

	as_string_8: STRING_8
		do
			create Result.make (count)
			Result.area.copy_data (area, area_first_index, 0, count)
			Result.set_count (count)
		end

feature {NONE} -- Implementation

	dispose
		do
			Precursor
			if is_attached (adopted_area) then
				eif_wean (adopted_area)
			end
		end

feature {NONE} -- Initialization

	area_first_index: INTEGER
		-- index of first character in `area'

	adopted_area: POINTER

	area: SPECIAL [CHARACTER]

end