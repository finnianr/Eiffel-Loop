note
	description: "8-bit little-endian C string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-01 16:28:42 GMT (Tuesday 1st August 2023)"
	revision: "8"

class
	EL_C_STRING_8_LE

inherit
	EL_C_STRING_8
		redefine
			code, put_item
		end

create
	make_owned, make_shared, make_owned_of_size, make_shared_of_size, make, make_from_string

feature -- Access

	code (index: INTEGER): NATURAL_32
			--
		do
			Result := read_natural_8_le (index - 1)
		end

feature -- Element change	

	put_item (value: NATURAL_32; index: INTEGER)
			--
		do
			put_natural_8_le (value.to_natural_8, index - 1)
		end

end