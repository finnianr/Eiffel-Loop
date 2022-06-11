note
	description: "Toggle button"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-11 14:39:55 GMT (Saturday 11th June 2022)"
	revision: "4"

class
	EL_TOGGLE_BUTTON

inherit
	EV_TOGGLE_BUTTON
		rename
			make_with_text as make_button_with_text,
			pixmap as button_pixmap
		undefine
			Default_pixmaps, set_text
		redefine
			implementation, initialize
		end

	EL_HAND_STYLE_POINTER_ACTION
		redefine
			implementation, initialize
		end

	EL_TEXTABLE
		rename
			make_with_text as make_button_with_text
		undefine
			initialize, is_in_default_state
		redefine
			implementation
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
			Precursor {EL_HAND_STYLE_POINTER_ACTION}
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	implementation: EV_TOGGLE_BUTTON_I

end