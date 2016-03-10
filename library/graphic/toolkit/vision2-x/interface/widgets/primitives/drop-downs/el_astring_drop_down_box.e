note
	description: "Summary description for {EL_STRING_DROP_DOWN_BOX}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-24 15:21:44 GMT (Wednesday 24th July 2013)"
	revision: "4"

class
	EL_ASTRING_DROP_DOWN_BOX

inherit
	EL_DROP_DOWN_BOX [EL_ASTRING]
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
	default_create, make, make_unadjusted, make_alphabetical, make_alphabetical_unadjusted

feature {NONE} -- Implementation

	displayed_text (string: EL_ASTRING): EL_ASTRING
		do
			Result := string
		end

end
