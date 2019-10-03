note
	description: "Array of 8 bit bytes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-03 12:34:00 GMT (Thursday   3rd   October   2019)"
	revision: "4"

class
	EL_BYTE_ARRAY

inherit
	TO_SPECIAL [NATURAL_8]
		rename
			set_area as make_from_area
		redefine
			is_equal
		end

	HASHABLE
		undefine
			is_equal
		end

create
	make_from_area, make_from_string, make_from_managed, make

convert
	make_from_string ({STRING}),
	make_from_area ({SPECIAL [NATURAL_8]}),

	to_string: {STRING},
	area: {SPECIAL [NATURAL_8]},
	to_data: {MANAGED_POINTER},
	to_array: {ARRAY [NATURAL_8]}

feature {NONE} -- Initialization

	make (size: INTEGER)
		do
			create area.make_filled (0, size)
		end

	make_from_managed (managed: MANAGED_POINTER; n: INTEGER)
		require
			valid_count: n <= managed.count
		do
			make (n)
			area.base_address.memory_copy (managed.item, n)
		end

	make_from_string (str: STRING)
		do
			make (str.count)
			area.base_address.memory_copy (str.area.base_address, str.count)
		end

feature -- Measurement

	count: INTEGER
		do
			Result := area.count
		end

	hash_code: INTEGER
			-- Hash code value
		local
			i, nb: INTEGER; l_area: like area
		do
			l_area := area
				-- The magic number `8388593' below is the greatest prime lower than
				-- 2^23 so that this magic number shifted to the left does not exceed 2^31.
			from i := 0; nb := count until i = nb loop
				Result := ((Result \\ 8388593) |<< 8) + l_area.item (i).to_integer_32
				i := i + 1
			end
		end

	read_natural_64 (index, byte_count: INTEGER): NATURAL_64
		require
			valid_byte_count: byte_count <= 8
			valid_index: index + byte_count <= count
		local
			i, end_index: INTEGER; l_area: like area
		do
			l_area := area; end_index := index + byte_count
			from i := index until i = end_index loop
				Result := (Result |<< 8) | l_area.item (i).to_natural_64
				i := i + 1
			end
		end

feature -- Conversion

	to_array: ARRAY [NATURAL_8]
		do
			create Result.make_from_special (area)
		end

	to_hex_string: STRING
		local
			i, offset, val: INTEGER
			l_area: like area
		do
			create Result.make_filled (' ', 2 * count)
			l_area := area
			from i := 0 until i = count loop
				offset := i* 2
				val := l_area [i]
				Result [offset + 1] := (val |>> 4).to_hex_character
				Result [offset + 2] := (val & 0xF).to_hex_character
				i := i + 1
			end
		end

	to_special: SPECIAL [NATURAL_8]
		do
			Result := area
		end

	to_data, to_managed_pointer: MANAGED_POINTER
		do
			create Result.share_from_pointer (area.base_address, count)
		end

	to_string: STRING
		do
			create Result.make_filled ('%U', count)
			Result.area.base_address.memory_copy (area.base_address, count)
		end

	to_uuid: EL_UUID
		require
			valid_size: count = 16 or count = 32
		local
			last_seg_64: NATURAL_64; found: BOOLEAN
		do
			inspect count
				when 16 then
					last_seg_64 := read_natural_64 (10, 6)
				when 32 then
					last_seg_64 := read_natural_64 (10, 8)
			else
				create Result.make_default
			end
			if not attached Result then
				create Result.make (
					read_natural_64 (0, 4).to_natural_32,

					read_natural_64 (4, 2).to_natural_16,
					read_natural_64 (6, 2).to_natural_16,
					read_natural_64 (8, 2).to_natural_16,

					last_seg_64
				)
			end
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := area.is_equal (other.area)
		end

end
