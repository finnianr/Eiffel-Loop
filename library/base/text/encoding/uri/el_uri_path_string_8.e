note
	description: "Encoded location"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-23 12:59:58 GMT (Saturday 23rd May 2020)"
	revision: "2"

class
	EL_URI_PATH_STRING_8

inherit
	EL_URI_STRING_8
		redefine
			set_reserved_character_set
		end

create
	make_encoded, make_empty, make

convert
	make_encoded ({STRING})

feature {NONE} -- Implementation

	set_reserved_character_set
		do
			reserved_character_set := Uri_reserved_chars.allowed_in_path
		end
end
