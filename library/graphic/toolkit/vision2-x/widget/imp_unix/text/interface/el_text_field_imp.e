note
	description: "Unix implementation of ${EL_TEXT_FIELD_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "8"

class
	EL_TEXT_FIELD_IMP

inherit
	EL_TEXT_FIELD_I
		undefine
			text_length, selected_text, hide_border
		redefine
			make, interface, on_change_actions
		end

	EV_TEXT_FIELD_IMP
		redefine
			make, interface, on_change_actions
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor {EV_TEXT_FIELD_IMP}
			Precursor {EL_TEXT_FIELD_I}
		end

feature {NONE} -- Event handling

	on_change_actions
		do
			Precursor {EV_TEXT_FIELD_IMP}
			Precursor {EL_TEXT_FIELD_I}
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EL_TEXT_FIELD note option: stable attribute end;

end