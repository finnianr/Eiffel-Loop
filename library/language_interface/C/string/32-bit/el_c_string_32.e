note
	description: "C string 32"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_C_STRING_32

inherit
	EL_C_STRING
		rename
			Natural_32_bytes as width
		end

create
	default_create, make_owned, make_shared, make_owned_of_size, make_shared_of_size, make, make_from_string

convert
	as_string: {ZSTRING}, as_string_8: {STRING}, as_string_32: {STRING_32},
	make_from_string ({STRING_32})

feature -- Access

	item (index: INTEGER): NATURAL_32
			--
		do
			Result := read_natural_32 ((index - 1) * width)
		end

	is_item_zero (address: POINTER): BOOLEAN
			--
		do
			share_from_pointer (address, width)
			Result := read_natural_32 (0) = 0
		end

feature -- Element change	

	put_item (value: NATURAL_32; index: INTEGER)
			--
		do
			put_natural_32 (value, (index - 1) * width)
		end

end