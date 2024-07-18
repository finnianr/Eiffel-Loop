note
	description: "Text imp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-18 12:23:52 GMT (Thursday 18th July 2024)"
	revision: "7"

class
	EL_TEXT_IMP

inherit
	EL_TEXT_I
		undefine
			text_length, selected_text
		redefine
			make, interface, on_change_actions
		end

	EV_TEXT_IMP
		redefine
			make, interface, on_change_actions
		end

	EL_UNIX_IMPLEMENTATION

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
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EL_TEXT note option: stable attribute end;

end