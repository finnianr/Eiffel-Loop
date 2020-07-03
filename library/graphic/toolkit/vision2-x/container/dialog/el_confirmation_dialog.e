note
	description: "A confirmation dialog with optional deferred localization"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-23 7:48:24 GMT (Tuesday 23rd July 2019)"
	revision: "4"

class
	EL_CONFIRMATION_DIALOG

inherit
	EV_CONFIRMATION_DIALOG
		rename
			set_position as set_absolute_position,
			set_x_position as set_absolute_x_position,
			set_y_position as set_absolute_y_position,
			add_button as add_locale_button,
			button as locale_button
		export
			{ANY} label
		undefine
			add_locale_button, locale_button, set_text
		redefine
			initialize, add_locale_button, locale_button
		end

	EL_MESSAGE_DIALOG
		undefine
			initialize
		end

create
	default_create,
	make_with_text,
	make_with_text_and_actions,
	make_with_template

feature {NONE} -- Initialization

	initialize
			-- Initialize `Current'.
		do
			Precursor {EV_CONFIRMATION_DIALOG}
			set_title (Locale * ev_confirmation_dialog_title)
			default_push_button.select_actions.extend (agent do ok_selected := True end)
		end

feature -- Status query

	ok_selected: BOOLEAN

end
