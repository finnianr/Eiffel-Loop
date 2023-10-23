note
	description: "32-bit C string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-27 16:12:25 GMT (Wednesday 27th September 2023)"
	revision: "10"

class
	EL_C_STRING_32

inherit
	EL_C_STRING
		rename
			Natural_32_bytes as width
		end

	EL_32_BIT_IMPLEMENTATION

create
	default_create, make_owned, make_shared, make_owned_of_size, make_shared_of_size, make, make_from_string

convert
	as_string: {ZSTRING}, as_string_8: {STRING}, as_string_32: {STRING_32},
	make_from_string ({STRING_32})

feature -- Access

	code (index: INTEGER): NATURAL_32
			--
		do
			Result := read_natural_32 ((index - 1) * width)
		end

feature -- Element change	

	put_item (value: NATURAL_32; index: INTEGER)
			--
		do
			put_natural_32 (value, (index - 1) * width)
		end

end