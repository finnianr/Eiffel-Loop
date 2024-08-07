note
	description: "Substring replacement edition for ${EL_STRING_EDITION_HISTORY}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-18 14:10:17 GMT (Thursday 18th July 2024)"
	revision: "1"

class
	EL_REPLACE_SUBSTRING_EDITION

inherit
	EL_COMPACTABLE_EDITION

create
	make, make_from_compact_edition

feature {NONE} -- Initialization

	make (a_edition_code: NATURAL_8; a_array_index, a_start_index, a_end_index: INTEGER)
		do
			edition_code := a_edition_code; array_index := a_array_index
			start_index := a_start_index; end_index := a_end_index
		end

feature -- Access

	array_index: INTEGER

	end_index: INTEGER

	start_index: INTEGER

feature {NONE} -- Constants

	Field_masks: EL_REFLECTED_FIELD_BIT_MASKS
		once
			create Result.make (Current, "[
				array_index := 1 .. 18
				start_index := 19 .. 40
				end_index := 41 .. 60
				edition_code := 61 .. 64
			]")
		end
end