note
	description: "Drop-down list of system fonts"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 21:28:08 GMT (Thursday 17th August 2023)"
	revision: "3"

class
	EL_FONT_FAMILY_DROP_DOWN_BOX

inherit
	EL_ZSTRING_DROP_DOWN_BOX
		rename
			make as make_drop_down
		end

	EL_FONT_PROPERTY
		export
			{NONE} all
		undefine
			copy, default_create, is_equal
		end

create
	make_system, make_monospace, make, make_query

feature {NONE} -- Initialization

	make (
		a_initial_value: READABLE_STRING_GENERAL; a_value_list: ITERABLE [ZSTRING]
		change_action: PROCEDURE [ZSTRING]
	)
		do
			make_drop_down (as_zstring (a_initial_value), a_value_list, change_action)
		end

	make_system (a_initial_value: READABLE_STRING_GENERAL; change_action: PROCEDURE [ZSTRING])
		do
			make_query (a_initial_value, change_action, Font_monospace | Font_proportional, 0, Void)
		end

	make_monospace (a_initial_value: READABLE_STRING_GENERAL; change_action: PROCEDURE [ZSTRING])
		-- restrict to fixed-width fonts
		do
			make_query (a_initial_value, change_action, Font_monospace, 0, Void)
		end

	make_query (
		a_initial_value: READABLE_STRING_GENERAL; change_action: PROCEDURE [ZSTRING]
		width_bitmap, type_bitmap: NATURAL_8; excluded_char_sets: detachable ARRAY [INTEGER]
	)
		-- restrict to fonts that have the exact combination of properties in `font_property_bitmap'
		-- See class {EL_FONT_PROPERTY}
		do
			if attached Rendered.Font_families.new_query_list (width_bitmap, type_bitmap, excluded_char_sets) as font_list then
				make (a_initial_value, font_list, change_action)
			end
		end

end
