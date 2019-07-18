note
	description: "Error dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 11:34:41 GMT (Monday 1st July 2019)"
	revision: "7"

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

feature {NONE} -- Initialization

	make (a_title, a_message: ZSTRING)
		deferred
		end

end
