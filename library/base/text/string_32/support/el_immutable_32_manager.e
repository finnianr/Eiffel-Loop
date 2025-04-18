note
	description: "Forces shared string data into an instance of ${IMMUTABLE_STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-09 12:51:34 GMT (Wednesday 9th April 2025)"
	revision: "13"

class
	EL_IMMUTABLE_32_MANAGER

inherit
	EL_IMMUTABLE_STRING_MANAGER [CHARACTER_32, READABLE_STRING_32, IMMUTABLE_STRING_32]
		undefine
			bit_count
		end

	EL_STRING_32_BIT_COUNTABLE [IMMUTABLE_STRING_32]

	CHARACTER_PROPERTY
		rename
			make as make_property,
			is_space as is_space_character
		export
			{NONE} all
		undefine
			default_create
		end

feature {NONE} -- Initialization

	initialize
		do
		-- cannot use shared extended string because it will cause a circular call
			create extended_string.make_empty
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

feature {NONE} -- Implementation

	is_space (a_area: SPECIAL [CHARACTER_32]; i: INTEGER): BOOLEAN
		do
			Result := is_space_character (a_area [i]) -- workaround for finalization bug
		end

	new_immutable_substring (str: IMMUTABLE_STRING_32; start_index, end_index: INTEGER): IMMUTABLE_STRING_32
		do
			Result := str.shared_substring (start_index, end_index)
		end

	string_area (str: READABLE_STRING_32): SPECIAL [CHARACTER_32]
		do
			if attached {STRING_32} str as str_32 then
				Result := str_32.area
			else
				Result := str.as_string_32.area
			end
		end

feature {NONE} -- Internal attributes

	extended_string: EL_READABLE_STRING_32

feature {NONE} -- Constants

	Shared_field_table: SPECIAL [INTEGER]
		once
			Result := new_field_table
		end

end