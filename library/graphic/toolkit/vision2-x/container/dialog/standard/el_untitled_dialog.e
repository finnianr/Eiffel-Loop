note
	description: "Untitled dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-14 12:58:36 GMT (Friday 14th August 2020)"
	revision: "1"

class
	EL_UNTITLED_DIALOG

inherit
	EV_UNTITLED_DIALOG
		rename
			set_position as set_absolute_position,
			set_x_position as set_absolute_x_position,
			set_y_position as set_absolute_y_position
		end

	EL_DIALOG
		undefine
			create_implementation
		end

end
