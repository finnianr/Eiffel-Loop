note
	description: "Integer edit field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

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
		a_parent_dialog: EL_WEL_DIALOG; pos: WEL_POINT; size: WEL_SIZE;
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