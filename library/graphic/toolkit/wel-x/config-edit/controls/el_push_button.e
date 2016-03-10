note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_PUSH_BUTTON

inherit
	WEL_PUSH_BUTTON
		rename
			make as make_button
		undefine
			on_key_down
		end
	
	EL_CONTROL
		export
			{NONE} all
		end
	
create
	make
		
feature {NONE} -- Initialization

	make (a_parent_dialog: EL_DIALOG; a_name: STRING; pos: WEL_POINT; size: WEL_SIZE; an_id: INTEGER)
			--
		do
			make_button (a_parent_dialog, a_name, pos.x, pos.y, size.width, size.height, an_id)
			make_control (a_parent_dialog)
			
--			Needs work on the layout manager to make this possible
--			if font.string_width (a_name) + 6 > size.width  then
--				set_width (size.width)
--			end
		end

end


