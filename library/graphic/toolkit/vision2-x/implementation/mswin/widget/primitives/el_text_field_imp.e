note
	description: "Summary description for {EL_TEXT_FIELD_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-04-03 17:16:02 GMT (Friday 3rd April 2015)"
	revision: "3"

class
	EL_TEXT_FIELD_IMP

inherit
	EL_TEXT_FIELD_I
		rename
			restore as restore_edit
		undefine
			text_length, hide_border
		redefine
			make, interface, on_change_actions
		end

	EV_TEXT_FIELD_IMP
		rename
			on_en_change as on_change_actions,
			undo as wel_undo
		redefine
			make, interface, on_change_actions, ignore_character_code
		end

	EL_UNDOABLE_TEXT_COMPONENT_IMP
		redefine
			ignore_character_code
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor {EV_TEXT_FIELD_IMP}
			Precursor {EL_TEXT_FIELD_I}
		end

feature {NONE} -- WEL Implementation

	ignore_character_code (a_character_code: INTEGER): BOOLEAN
		do
			Result := Precursor {EV_TEXT_FIELD_IMP} (a_character_code) or else
					    Precursor {EL_UNDOABLE_TEXT_COMPONENT_IMP} (a_character_code)
		end

feature {NONE} -- Event handling

	on_change_actions
		do
			Precursor {EV_TEXT_FIELD_IMP}
			Precursor {EL_TEXT_FIELD_I}
			empty_undo_buffer
				 -- Needed to suppress default Ctrl-z action
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EL_TEXT_FIELD note option: stable attribute end;

end
