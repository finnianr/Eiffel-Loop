note
	description: "Single character edition for ${EL_STRING_EDITION_HISTORY}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-13 8:33:58 GMT (Sunday 13th October 2024)"
	revision: "2"

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
				start_index := 1 .. 31
				character := 32 .. 60
				edition_code := 61 .. 64
			]")
		end
end