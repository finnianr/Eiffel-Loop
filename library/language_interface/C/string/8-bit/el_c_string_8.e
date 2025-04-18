note
	description: "8-bit C string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-19 15:08:40 GMT (Saturday 19th April 2025)"
	revision: "13"

class
	EL_C_STRING_8

inherit
	EL_C_STRING
		rename
			Natural_8_bytes as width,
			item as item_32,
			as_array as as_array_32,
			make_from_string as make_from_string_general
		redefine
			as_string_8, item_32
		end

	EL_8_BIT_IMPLEMENTATION

	EL_SHARED_IMMUTABLE_8_MANAGER

create
	default_create, make_owned, make_shared, make_owned_of_size, make_shared_of_size,
	make, make_from_string_general, make_from_string

convert
	make_from_string ({STRING_8, IMMUTABLE_STRING_8}), as_string_8: {STRING}

feature {NONE} -- Initialization

	make_from_string (string: READABLE_STRING_8)
			--
		local
			index_lower: INTEGER
		do
			count := string.count
			capacity := count + 1
			make_buffer (capacity)
			if attached Character_area_8.get_lower (string, $index_lower) as area then
				put_special_character_8 (area, index_lower, 0, count)
				put_natural_8 (0, count)
			end
		end

feature -- Access

	code (index: INTEGER): NATURAL_32
			--
		do
			Result := read_natural_8 (index - 1)
		end

	item_32 (index: INTEGER): CHARACTER_32
			--
		do
			Result := read_character (index - 1)
		end

	item (index: INTEGER): CHARACTER_8
			--
		require
			valid_index: index >= 1 and index <= count
		do
			Result := read_character (index - 1)
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
			put_natural_8 (value.to_natural_8, index - 1)
		end

feature {NONE} -- Implementation

	shared_immutable_8: IMMUTABLE_STRING_8
			--
		do
			Immutable_8.set_item (as_array, 0, count)
			Result := Immutable_8.item
		end
end