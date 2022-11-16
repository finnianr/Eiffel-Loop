note
	description: "Textable widget settable from string of type [$source ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

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