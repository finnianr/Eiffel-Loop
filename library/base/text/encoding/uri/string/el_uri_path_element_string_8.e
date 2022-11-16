note
	description: "URL encoded string with unescaped path separator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "11"

class
	EL_URI_PATH_ELEMENT_STRING_8

inherit
	EL_URI_STRING_8
		redefine
			is_reserved
		end

create
	make_encoded, make_empty, make

convert
	make_encoded ({STRING})

feature {NONE} -- Implementation

	is_reserved (c: CHARACTER_32): BOOLEAN
		do
			Result := is_allowed_in_path_element (c)
		end

end