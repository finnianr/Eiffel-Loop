note
	description: "URL encoded string with unescaped path separator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-11 14:20:48 GMT (Tuesday 11th February 2025)"
	revision: "14"

class
	EL_URI_PATH_ELEMENT_STRING_8

inherit
	EL_URI_STRING_8
		redefine
			is_reserved
		end

create
	make_encoded, make_empty, make, make_from_general

convert
	make_encoded ({STRING})

feature {NONE} -- Implementation

	is_reserved (c: CHARACTER_32): BOOLEAN
		do
			Result := is_allowed_in_path_element (c)
		end

end