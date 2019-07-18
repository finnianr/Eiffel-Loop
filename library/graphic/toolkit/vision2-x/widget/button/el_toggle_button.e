note
	description: "Toggle button"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-15 11:18:31 GMT (Monday 15th July 2019)"
	revision: "1"

class
	EL_TOGGLE_BUTTON

inherit
	EV_TOGGLE_BUTTON
		rename
			make_with_text as make_button_with_text
		redefine
			implementation
		end

	EL_DESELECTABLE_WIDGET
		undefine
			is_in_default_state
		redefine
			implementation
		end

create
	default_create, make, make_with_text

feature {EV_ANY, EV_ANY_I} -- Implementation

	implementation: EV_TOGGLE_BUTTON_I

end
