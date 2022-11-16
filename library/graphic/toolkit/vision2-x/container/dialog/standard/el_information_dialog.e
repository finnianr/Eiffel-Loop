note
	description: "An information dialog with optional deferred localization"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "10"

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
			add_locale_button, locale_button, set_text, set_title
		end

	EL_MESSAGE_DIALOG
		undefine
			initialize
		end

create
	default_create, make_with_text, make_with_template

end