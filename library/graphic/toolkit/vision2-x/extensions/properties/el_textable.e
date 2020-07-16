note
	description: "Textable widget settable from string of type [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-16 9:49:43 GMT (Thursday 16th July 2020)"
	revision: "1"

deferred class
	EL_TEXTABLE

inherit
	EV_TEXTABLE
		redefine
			set_text
		end

	EL_MODULE_ZSTRING

feature -- Element change

	set_text (a_text: separate READABLE_STRING_GENERAL)
		do
			Precursor (Zstring.to_unicode_general (a_text))
		end

end
