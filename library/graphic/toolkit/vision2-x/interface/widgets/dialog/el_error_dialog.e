note
	description: "Error dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-30 11:51:34 GMT (Saturday 30th June 2018)"
	revision: "1"

class
	EL_ERROR_DIALOG

inherit
	EV_ERROR_DIALOG
		rename
			set_position as set_absolute_position,
			set_x_position as set_absolute_x_position,
			set_y_position as set_absolute_y_position,
			add_button as add_locale_button,
			button as locale_button
		export
			{ANY} label
		undefine
			add_locale_button, locale_button
		redefine
			initialize
		end

	EL_MESSAGE_DIALOG
		undefine
			initialize
		end

create
	default_create, make_with_text

feature {NONE} -- Initialization

	initialize
			-- Initialize `Current'.
		do
			Precursor {EV_ERROR_DIALOG}
			set_title (Locale * ev_error_dialog_title)
		end

feature -- Access

	retry_button: like default_push_button
		do
			Result := default_push_button
		end
end
