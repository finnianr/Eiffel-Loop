note
	description: "Text imp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

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