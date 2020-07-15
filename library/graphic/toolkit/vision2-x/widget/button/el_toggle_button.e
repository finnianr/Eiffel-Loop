note
	description: "Toggle button"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-15 10:48:55 GMT (Wednesday 15th July 2020)"
	revision: "2"

class
	EL_TOGGLE_BUTTON

inherit
	EV_TOGGLE_BUTTON
		rename
			make_with_text as make_button_with_text,
			pixmap as button_pixmap
		redefine
			implementation, initialize
		end

	EL_HAND_POINTER_BUTTON
		redefine
			initialize
		end

	EL_DESELECTABLE_WIDGET
		undefine
			is_in_default_state, initialize
		redefine
			implementation
		end

create
	default_create, make, make_with_text

feature {NONE} -- Initialization

	initialize
		do
			Precursor {EV_TOGGLE_BUTTON}
			Precursor {EL_HAND_POINTER_BUTTON}
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	implementation: EV_TOGGLE_BUTTON_I

end
