note
	description: "Textable widget settable from string of type ${ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 21:06:16 GMT (Thursday 17th August 2023)"
	revision: "6"

deferred class
	EL_TEXTABLE

inherit
	EV_TEXTABLE
		redefine
			set_text
		end

	EL_STRING_GENERAL_ROUTINES

feature -- Element change

	set_text (a_text: separate READABLE_STRING_GENERAL)
		do
			Precursor (to_unicode_general (a_text))
		end

end