note
	description: "CSV parser for lines encoded as UTF-8"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-22 12:40:58 GMT (Wednesday 22nd December 2021)"
	revision: "2"

class
	EL_UTF_8_COMMA_SEPARATED_LINE_PARSER

inherit
	EL_COMMA_SEPARATED_LINE_PARSER
		redefine
			new_string
		end
create
	make

feature {NONE} -- Implementation

	new_string: ZSTRING
		do
			create Result.make_from_utf_8 (field_string)
		end

end