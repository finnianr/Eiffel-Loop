note
	description: "CSV parser for lines encoded as UTF-8"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-14 17:36:22 GMT (Thursday 14th December 2017)"
	revision: "1"

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
