note
	description: "Encoded location"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-12 9:36:11 GMT (Sunday 12th September 2021)"
	revision: "4"

class
	EL_URI_PATH_STRING_8

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
			Result := is_allowed_in_path (c)
		end

end