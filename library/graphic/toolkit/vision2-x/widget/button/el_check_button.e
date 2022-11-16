note
	description: "Check button"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_CHECK_BUTTON

inherit
	EV_CHECK_BUTTON
		rename
			make_with_text as make_button_with_text
		undefine
			set_text
		redefine
			implementation
		end

	EL_DESELECTABLE_WIDGET
		undefine
			is_in_default_state
		redefine
			implementation
		end

	EL_TEXTABLE
		rename
			make_with_text as make_button_with_text
		undefine
			initialize, is_in_default_state
		redefine
			implementation
		end

create
	default_create, make, make_with_text

feature {EV_ANY, EV_ANY_I} -- Implementation

	implementation: EV_CHECK_BUTTON_I

end