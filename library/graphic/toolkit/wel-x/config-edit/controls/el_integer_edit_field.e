note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_INTEGER_EDIT_FIELD

inherit
	EL_TEXT_EDIT_FIELD
		rename
			make as make_text_field
		redefine
			is_valid_text
		end
		
create
	make

feature {NONE} -- Initialization

	make (
		a_parent_dialog: EL_DIALOG; pos: WEL_POINT; size: WEL_SIZE;
		a_field_value: EL_EDITABLE_INTEGER
	)
			--
		do
			make_text_field (a_parent_dialog, pos, size, a_field_value)
		end

feature -- Status query

	is_valid_text: BOOLEAN
			--
		do
			Result := text.is_integer or text.is_empty		
		end
		

end

