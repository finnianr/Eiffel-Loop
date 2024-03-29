note
	description: "Drop down box for strings of type ${ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "10"

class
	EL_ZSTRING_DROP_DOWN_BOX

inherit
	EL_DROP_DOWN_BOX [ZSTRING]
		rename
			selected_text as selected_text_32,
			displayed_value as displayed_text,
			set_text as set_combo_text,
			set_value as set_text,
			selected_value as selected_text
		redefine
			displayed_text
		end

	EL_STRING_GENERAL_ROUTINES

create
	default_create, make, make_unadjusted, make_sorted, make_unadjusted_sorted

feature {NONE} -- Implementation

	displayed_text (string: ZSTRING): ZSTRING
		do
			Result := string
		end

end