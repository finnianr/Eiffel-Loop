note
	description: "C string 8"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-12 10:40:43 GMT (Wednesday 12th July 2023)"
	revision: "7"

class
	EL_C_STRING_8

inherit
	EL_C_STRING
		rename
			Natural_8_bytes as width,
			as_array as as_array_32,
			make_from_string as make_from_string_general
		redefine
			as_string_8
		end

	EL_SHARED_IMMUTABLE_8_MANAGER

create
	default_create, make_owned, make_shared, make_owned_of_size, make_shared_of_size,
	make, make_from_string_general, make_from_string

convert
	make_from_string ({STRING}), as_string_8: {STRING}

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

feature -- Conversion

	as_array: SPECIAL [CHARACTER]
		-- character array with terminating NULL character
		do
			create Result.make_filled ('%U', count + 1)
			read_into_special_character_8 (Result, 0, 0, count)
		end

	as_string_8: STRING
			--
		do
			create Result.make_from_string (shared_immutable_8)
		end

feature -- Element change	

	put_item (value: NATURAL_32; index: INTEGER)
			--
		do
			put_natural_8 (value.to_natural_8, (index - 1) * width)
		end

feature {NONE} -- Implementation

	shared_immutable_8: IMMUTABLE_STRING_8
			--
		do
			Immutable_8.set_item (as_array, 0, count)
			Result := Immutable_8.item
		end
end