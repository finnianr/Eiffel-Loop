note
	description: "An information dialog with optional deferred localization"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-23 11:25:48 GMT (Sunday 23rd August 2020)"
	revision: "8"

class
	EL_INFORMATION_DIALOG

inherit
	EV_INFORMATION_DIALOG
		rename
			add_button as add_locale_button,
			button as locale_button
		export
			{ANY} label
		undefine
			add_locale_button, locale_button, set_text
		redefine
			initialize
		end

	EL_MESSAGE_DIALOG
		undefine
			initialize
		end

create
	default_create, make_with_text, make_with_template

feature {NONE} -- Initialization

	initialize
			-- Initialize `Current'.
		do
			Precursor {EV_INFORMATION_DIALOG}
			set_title (Locale * ev_information_dialog_title)
		end

end
