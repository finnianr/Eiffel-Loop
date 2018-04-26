note
	description: "Summary description for {SQUARE_BRACKET_ESCAPER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-22 9:26:01 GMT (Sunday 22nd April 2018)"
	revision: "1"

class
	SQUARE_BRACKET_ESCAPER

inherit
	EL_ZSTRING_ESCAPER
		rename
			make as make_escaper
		redefine
			append_escape_sequence
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_escaper ("[]")
		end

feature {NONE} -- Implementation

	append_escape_sequence (str: like once_buffer; code: NATURAL)
		do
			inspect code
				when 91 then
					str.append_string_general (once "&lsqb;")

				when 93 then
					str.append_string_general (once "&rsqb;")
			else

			end
		end

end
