note
	description: "Message dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-23 7:31:28 GMT (Tuesday 23rd July 2019)"
	revision: "3"

class
	EL_MESSAGE_DIALOG

inherit
	EV_MESSAGE_DIALOG
		rename
			set_position as set_absolute_position,
			set_x_position as set_absolute_x_position,
			set_y_position as set_absolute_y_position,
			add_button as add_locale_button,
			button as locale_button
		export
			{ANY} label
		redefine
			add_locale_button, locale_button, set_text
		end

	EL_WINDOW

	EL_MODULE_DEFERRED_LOCALE

	EL_MODULE_ZSTRING

feature {NONE} -- Initialization

	make_with_template (template: READABLE_STRING_GENERAL; inserts: TUPLE)
		do
			make_with_text (Zstring.as_zstring (template).substituted_tuple (inserts).to_unicode)
		end

feature -- Element change

	set_label_font (a_font: EL_FONT)
		do
			label.set_font (a_font)
		end

	set_text (a_text: READABLE_STRING_GENERAL)
		do
			Precursor (Zstring.to_unicode_general (a_text))
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
