note
	description: "Toggle button"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-16 9:29:35 GMT (Thursday 16th July 2020)"
	revision: "3"

class
	EL_TOGGLE_BUTTON

inherit
	EV_TOGGLE_BUTTON
		rename
			make_with_text as make_button_with_text,
			pixmap as button_pixmap
		undefine
			set_text
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
