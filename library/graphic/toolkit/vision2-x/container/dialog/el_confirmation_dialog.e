note
	description: "A confirmation dialog with optional deferred localization"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-08-04 12:50:24 GMT (Friday 4th August 2017)"
	revision: "2"

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
		redefine
			initialize, add_locale_button, locale_button
		end

	EL_WINDOW
		undefine
			default_create, copy
		end

	EL_MODULE_DEFERRED_LOCALE
		undefine
			default_create, copy
		end

create
	default_create,
	make_with_text,
	make_with_text_and_actions

feature {NONE} -- Initialization

	initialize
			-- Initialize `Current'.
		do
			Precursor
			set_title (Locale * ev_confirmation_dialog_title)
		end

feature {NONE} -- Implementation

	add_locale_button (english_text: READABLE_STRING_GENERAL)
		do
			Precursor (Locale.translation (english_text).to_unicode)
		end

	locale_button (english_text: READABLE_STRING_GENERAL): EV_BUTTON
		do
			Result := Precursor (Locale * english_text)
		end
end
