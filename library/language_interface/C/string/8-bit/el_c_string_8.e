note
	description: "Summary description for {EL_C_STRING_8}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "5"

class
	EL_C_STRING_8

inherit
	EL_C_STRING
		rename
			Natural_8_bytes as width,
			make_from_string as make_from_string_general
		end

create
	default_create, make_owned, make_shared, make_owned_of_size, make_shared_of_size,
	make, make_from_string_general, make_from_string

convert
	make_from_string ({STRING}),
	as_string_8: {STRING}

feature {NONE} -- Initialization

	make_from_string (string: STRING)
			--
		do
			count := string.count
			capacity := count + 1
			make_buffer (capacity)
			base_address.memory_copy (string.area.base_address, capacity)
		end

feature -- Access

	item (index: INTEGER): NATURAL_32
			--
		do
			Result := read_natural_8 ((index - 1) * width)
		end

	is_item_zero (address: POINTER): BOOLEAN
			--
		do
			share_from_pointer (address, width)
			Result := read_natural_8 (0) = 0
		end

feature -- Element change	

	put_item (value: NATURAL_32; index: INTEGER)
			--
		do
			put_natural_8 (value.to_natural_8, (index - 1) * width)
		end

end
