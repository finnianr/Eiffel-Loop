note
	description: "Zstring drop down box"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-21 8:17:57 GMT (Friday 21st December 2018)"
	revision: "6"

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

create
	default_create, make, make_unadjusted, make_sorted, make_unadjusted_sorted

feature {NONE} -- Implementation

	displayed_text (string: ZSTRING): ZSTRING
		do
			Result := string
		end

end
