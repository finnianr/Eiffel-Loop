note
	description: "XML [$source EL_ZSTRING] escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-02 12:02:10 GMT (Saturday 2nd May 2020)"
	revision: "7"

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

	is_escaped (code: NATURAL): BOOLEAN
		do
			if escape_128_plus and then codec.z_code_as_unicode (code) > 128 then
				Result := True
			else
				Result := code_table.has_key (code)
			end
		end

end
