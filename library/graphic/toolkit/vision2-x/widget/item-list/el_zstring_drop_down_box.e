note
	description: "Zstring drop down box"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

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