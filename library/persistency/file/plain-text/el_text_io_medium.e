note
	description: "Text buffer medium"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "4"

class
	EL_TEXT_IO_MEDIUM

inherit
	EL_UTF_8_TEXT_IO_MEDIUM
		redefine
			set_default_encoding, text, put_string, put_astring, put_string_32
		end

create
	make, make_open_write, make_open_write_to_text, make_open_read_from_text

feature -- Access

	text: ASTRING

feature -- Output

	put_string (str: READABLE_STRING_GENERAL)
		do
			text.append_string (str)
		end

	put_astring (str: ASTRING)
		do
			text.append (str)
		end

feature -- Element change

	set_default_encoding
		do
			set_latin_1_encoding
		end

feature {NONE} -- Implementation

	put_string_32 (str_32: STRING_32)
		do
			text.append_string (str_32)
		end
end
