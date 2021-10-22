note
	description: "A confirmation dialog with optional deferred localization"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-22 11:12:01 GMT (Friday 22nd October 2021)"
	revision: "8"

class
	EL_CONFIRMATION_DIALOG

inherit
	EV_CONFIRMATION_DIALOG
		rename
			add_button as add_locale_button,
			button as locale_button
		export
			{ANY} label
		undefine
			add_locale_button, locale_button, set_text, set_title
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
			default_push_button.select_actions.extend (agent do ok_selected := True end)
		end

feature -- Status query

	ok_selected: BOOLEAN

end