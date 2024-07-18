note
	description: "Text removal edition for ${EL_STRING_EDITION_HISTORY}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-18 14:10:34 GMT (Thursday 18th July 2024)"
	revision: "1"

class
	EL_REMOVE_TEXT_EDITION

inherit
	EL_COMPACTABLE_EDITION

create
	make, make_from_compact_edition

feature {NONE} -- Initialization

	make (a_edition_code: NATURAL_8; a_start_index, a_end_index: INTEGER)
		do
			edition_code := a_edition_code; start_index := a_start_index
			end_index := a_end_index
		end

feature -- Access

	end_index: INTEGER

	start_index: INTEGER

feature {NONE} -- Constants

	Field_masks: EL_REFLECTED_FIELD_BIT_MASKS
		once
			create Result.make (Current, "[
				start_index := 1 .. 30
				end_index := 31 .. 60
				edition_code := 61 .. 64
			]")
		end
end