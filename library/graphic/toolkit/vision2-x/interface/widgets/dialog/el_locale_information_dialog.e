note
	description: "Summary description for {EL_LOCALE_INFORMATION_DIALOG}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-01-05 16:29:48 GMT (Thursday 5th January 2017)"
	revision: "2"

class
	EL_LOCALE_INFORMATION_DIALOG

inherit
	EV_INFORMATION_DIALOG
		rename
			set_position as set_absolute_position,
			set_x_position as set_absolute_x_position,
			set_y_position as set_absolute_y_position
		export
			{ANY} label
		undefine
			ev_ok, ev_save, ev_cancel, ev_confirmation_dialog_title
		end

	EV_LOCALE_DIALOG_CONSTANTS
		undefine
			default_create, copy
		end

	EL_WINDOW
		undefine
			default_create, copy
		end

create
	default_create, make_with_text

feature -- Element change

	set_label_font (a_font: EL_FONT)
		do
			label.set_font (a_font)
		end
end
