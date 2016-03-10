note
	description: "Summary description for {EL_TEXT_IMP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-04-03 17:16:15 GMT (Friday 3rd April 2015)"
	revision: "3"

class
	EL_TEXT_IMP

inherit
	EL_TEXT_I
		rename
			restore as restore_edit
		undefine
			text_length, selected_text
		redefine
			make, interface, on_change_actions
		end

	EV_TEXT_IMP
		rename
			on_en_change as on_change_actions,
			undo as wel_undo
		undefine
			ignore_character_code
		redefine
			make, interface, on_change_actions
		end

	EL_UNDOABLE_TEXT_COMPONENT_IMP

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor {EV_TEXT_IMP}
			Precursor {EL_TEXT_I}
		end

feature {NONE} -- Event handling

	on_change_actions
		do
			Precursor {EV_TEXT_IMP}
			Precursor {EL_TEXT_I}
			empty_undo_buffer
				 -- Needed to suppress default Ctrl-z action
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EL_TEXT note option: stable attribute end;

end
