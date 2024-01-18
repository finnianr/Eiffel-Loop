note
	description: "[
		Button with hand-pointer for mouse-over and settable from ${ZSTRING}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "12"

class
	EL_BUTTON

inherit
	EV_BUTTON
		undefine
			Default_pixmaps, set_text
		redefine
			initialize, implementation, set_text
		end

	EL_HAND_STYLE_POINTER_ACTION
		redefine
			initialize, implementation
		end

	EL_TEXTABLE
		undefine
			initialize, is_in_default_state
		redefine
			implementation
		end

create
	default_create, make_with_text, make_with_text_and_action

feature {NONE} -- Initialization

	initialize
		do
			Precursor {EV_BUTTON}
			Precursor {EL_HAND_STYLE_POINTER_ACTION}
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	implementation: EV_BUTTON_I

end