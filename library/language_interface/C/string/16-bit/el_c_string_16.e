note
	description: "Summary description for {EL_C_STRING_16}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_C_STRING_16

inherit
	EL_C_STRING
		rename
			Natural_16_bytes as width
		end

create
	default_create, make_owned, make_shared, make_owned_of_size, make_shared_of_size, make, make_from_string

convert
	as_string_8: {STRING}, as_string_32: {STRING_32}

feature -- Access

	item (index: INTEGER): NATURAL_32
			--
		do
			Result := read_natural_16 ((index - 1) * width)
		end

	is_item_zero (address: POINTER): BOOLEAN
			--
		do
			share_from_pointer (address, width)
			Result := read_natural_16 (0) = 0
		end

feature -- Element change	

	put_item (value: NATURAL_32; index: INTEGER)
			--
		do
			put_natural_16 (value.to_natural_16, (index - 1) * width)
		end

end