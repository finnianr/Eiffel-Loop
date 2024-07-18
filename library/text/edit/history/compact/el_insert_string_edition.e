note
	description: "String insertion edition for ${EL_STRING_EDITION_HISTORY}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-18 15:01:46 GMT (Thursday 18th July 2024)"
	revision: "1"

class
	EL_INSERT_STRING_EDITION

inherit
	EL_COMPACTABLE_EDITION

create
	make, make_from_compact_edition

feature {NONE} -- Initialization

	make (a_edition_code: NATURAL_8; a_array_index, a_start_index: INTEGER)
		do
			edition_code := a_edition_code; array_index := a_array_index
			start_index := a_start_index
		end

feature -- Access

	array_index: INTEGER

	start_index: INTEGER

feature {NONE} -- Constants

	Field_masks: EL_REFLECTED_FIELD_BIT_MASKS
		once
			create Result.make (Current, "[
				start_index := 1 .. 31
				array_index := 32 .. 60
				edition_code := 61 .. 64
			]")
		end
end