note
	description: "CSV parser for lines encoded as UTF-8"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-22 8:22:55 GMT (Wednesday 22nd June 2022)"
	revision: "3"

class
	CSV_UTF_8_LINE_PARSER

inherit
	CSV_LINE_PARSER
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
