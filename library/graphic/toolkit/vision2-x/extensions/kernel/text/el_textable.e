note
	description: "Textable widget settable from string of type ${ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-05 12:08:01 GMT (Saturday 5th April 2025)"
	revision: "9"

deferred class
	EL_TEXTABLE

inherit
	EV_TEXTABLE
		redefine
			set_text
		end

	EL_READABLE_STRING_GENERAL_ROUTINES_I
		export
			{NONE} all
		end

feature -- Element change

	set_text (a_text: separate READABLE_STRING_GENERAL)
		do
			Precursor (to_unicode_general (a_text))
		end

end