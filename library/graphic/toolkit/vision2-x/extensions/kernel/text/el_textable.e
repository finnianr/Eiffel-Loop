note
	description: "Textable widget settable from string of type [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-05 12:19:18 GMT (Tuesday 5th January 2021)"
	revision: "3"

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
			s: EL_ZSTRING_ROUTINES
		do
			Precursor (s.to_unicode_general (a_text))
		end

end