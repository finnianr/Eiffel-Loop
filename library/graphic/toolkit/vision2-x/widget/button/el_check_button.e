note
	description: "Check button"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-21 12:03:17 GMT (Thursday 21st February 2019)"
	revision: "1"

class
	EL_CHECK_BUTTON

inherit
	EV_CHECK_BUTTON
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

	implementation: EV_CHECK_BUTTON_I

end
