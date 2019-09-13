note
	description: "Xml zstring escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-13 8:20:02 GMT (Friday 13th September 2019)"
	revision: "6"

class
	EL_XML_ZSTRING_ESCAPER

inherit
	EL_XML_GENERAL_ESCAPER
		redefine
			append_escape_sequence, is_escaped
		end

	EL_ZSTRING_ESCAPER
		rename
			make as make_escaper
		undefine
			append_escape_sequence, is_escaped
		end

	EL_SHARED_ZCODEC

create
	make, make_128_plus

feature {NONE} -- Implementation

	append_escape_sequence (str: like once_buffer; code: NATURAL)
		do
			str.append_string_general (escape_sequence (codec.z_code_as_unicode (code)))
		end

	is_escaped (table: like code_table; code: NATURAL): BOOLEAN
		do
			Result := table.found or else (escape_128_plus and then codec.z_code_as_unicode (code) > 128)
		end

end
