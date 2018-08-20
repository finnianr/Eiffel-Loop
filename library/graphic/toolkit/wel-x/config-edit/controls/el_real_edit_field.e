note
	description: "Real edit field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-07-04 11:40:47 GMT (Wednesday 4th July 2018)"
	revision: "4"

class
	EL_REAL_EDIT_FIELD

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
		a_field_value: EL_EDITABLE_REAL
	)
			--
		do
			make_text_field (a_parent_dialog, pos, size, a_field_value)
		end

feature -- Status query

	is_valid_text: BOOLEAN
			--
		do
			Result := text.is_real or text.is_empty
		end
		


end
