note
	description: "Extend version of ${EV_WEL_FONT_ENUMERATOR_IMP}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "3"

class
	EL_WEL_FONT_ENUMERATOR_IMP

inherit
	EV_WEL_FONT_ENUMERATOR_IMP
		rename
			font_faces as new_font_faces
		end

	WEL_FONT_PITCH_CONSTANTS
		export
			{NONE} all
		undefine
			copy, default_create
		end

	WEL_FONT_FAMILY_CONSTANTS
		export
			{NONE} all
		undefine
			copy, default_create
		end

create
	default_create

feature -- Factory

	new_font_families_map: EL_ARRAYED_MAP_LIST [STRING_32, INTEGER]
		do
			create Result.make_from_keys (new_font_families, agent family_char_set)
		end

feature {NONE} -- Implementation

	family_char_set (family: STRING_32): INTEGER
		do
			if log_fonts.has_key (family) then
				Result := log_fonts.found_item.char_set
			end
		end

	new_font_families: EL_SORTABLE_ARRAYED_LIST [STRING_32]
		do
			create Result.make_from_array (new_font_faces.to_array)
			Result.ascending_sort
		end

end