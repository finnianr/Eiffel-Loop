note
	description: "Textable widget settable from string of type ${ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-23 7:30:28 GMT (Friday 23rd May 2025)"
	revision: "10"

deferred class
	EL_TEXTABLE

inherit
	EV_TEXTABLE
		redefine
			set_text
		end

feature -- Element change

	set_text (a_text: separate READABLE_STRING_GENERAL)
		local
			sg: EL_READABLE_STRING_GENERAL_ROUTINES
		do
			Precursor (sg.to_unicode_general (a_text))
		end

end