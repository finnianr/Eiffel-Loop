note
	description: "Interface to `TagLib:FileName'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:04 GMT (Monday 3rd January 2022)"
	revision: "3"

class
	TL_FILE_NAME

inherit
	TL_FILE_NAME_I

	EL_C_OBJECT

	TL_FILE_NAME_CPP_API

create
	make, make_from_string

convert
	make ({FILE_PATH})

feature {NONE} -- Implementation

	make_from_string (name: ZSTRING)
		do
		end
end
