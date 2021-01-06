note
	description: "Message dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-05 12:19:00 GMT (Tuesday 5th January 2021)"
	revision: "8"

class
	EL_MESSAGE_DIALOG

inherit
	EV_MESSAGE_DIALOG
		rename
			add_button as add_locale_button,
			button as locale_button
		export
			{ANY} label
		redefine
			add_locale_button, locale_button, set_text
		end

	EL_MODULE_DEFERRED_LOCALE

feature {NONE} -- Initialization

	make_with_template (template: READABLE_STRING_GENERAL; inserts: TUPLE)
		local
			s: EL_ZSTRING_ROUTINES
		do
			make_with_text (s.as_zstring (template).substituted_tuple (inserts).to_unicode)
		end

feature -- Element change

	set_label_font (a_font: EL_FONT)
		do
			label.set_font (a_font)
		end

	set_text (a_text: READABLE_STRING_GENERAL)
		local
			s: EL_ZSTRING_ROUTINES
		do
			Precursor (s.to_unicode_general (a_text))
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