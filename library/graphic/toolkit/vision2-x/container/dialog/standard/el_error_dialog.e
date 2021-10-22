note
	description: "Error dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-22 11:11:38 GMT (Friday 22nd October 2021)"
	revision: "5"

class
	EL_ERROR_DIALOG

inherit
	EV_ERROR_DIALOG
		rename
			add_button as add_locale_button,
			button as locale_button
		export
			{ANY} label
		undefine
			add_locale_button, locale_button, set_text, set_title
		end

	EL_MESSAGE_DIALOG
		undefine
			initialize
		end

create
	default_create, make_with_text

feature -- Access

	retry_button: like default_push_button
		do
			Result := default_push_button
		end
end