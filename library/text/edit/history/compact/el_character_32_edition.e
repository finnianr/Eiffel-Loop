note
	description: "Single character edition for ${EL_STRING_EDITION_HISTORY}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-15 11:20:57 GMT (Tuesday 15th October 2024)"
	revision: "3"

class
	EL_CHARACTER_32_EDITION

inherit
	EL_COMPACTABLE_EDITION

create
	make, make_from_compact_edition

feature {NONE} -- Initialization

	make (a_edition_code: NATURAL_8; a_start_index: INTEGER; a_character: CHARACTER_32)
		do
			edition_code := a_edition_code; start_index := a_start_index
			character := a_character
		end

feature -- Access

	character: CHARACTER_32

	start_index: INTEGER

feature {NONE} -- Constants

	Range_table: EL_ATTRIBUTE_BIT_RANGE_TABLE
		once
			create Result.make (Current, "[
				edition_code := 1 .. 3
				start_index := 4 .. 34
				character := 35 .. 64
			]")
		end
end