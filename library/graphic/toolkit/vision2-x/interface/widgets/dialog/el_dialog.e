note
	description: "Error dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-30 11:02:22 GMT (Saturday 30th June 2018)"
	revision: "5"

deferred class
	EL_DIALOG

inherit
	EV_DIALOG
		rename
			set_position as set_absolute_position,
			set_x_position as set_absolute_x_position,
			set_y_position as set_absolute_y_position
		end

	EL_WINDOW
		undefine
			default_create, copy
		end

feature {NONE} -- Initialization

	make (a_title, a_message: ZSTRING)
		deferred
		end

end
