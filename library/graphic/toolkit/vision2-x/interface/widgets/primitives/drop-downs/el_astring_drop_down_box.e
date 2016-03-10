note
	description: "Summary description for {EL_STRING_DROP_DOWN_BOX}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "6"

class
	EL_ASTRING_DROP_DOWN_BOX

inherit
	EL_DROP_DOWN_BOX [ASTRING]
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

	displayed_text (string: ASTRING): ASTRING
		do
			Result := string
		end

end
