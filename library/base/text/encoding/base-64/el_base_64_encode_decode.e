note
	description: "Base class for base-64 encoder and decoder"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-29 14:15:18 GMT (Sunday 29th January 2023)"
	revision: "3"

class
	EL_BASE_64_ENCODE_DECODE

feature {NONE} -- Initialization

	make
		do
			create triplet.make_empty (3)
			create quartet.make_filled (Padding_code, 4)
		ensure
			triplet_capacity: triplet.capacity = 3
			quartet_size: quartet.count = 4
		end

feature {NONE} -- Implementation

	alignment_shift (sextet_count, octet_count: INTEGER): INTEGER
		do
			Result := sextet_count * 6 - octet_count * 8
		end

	fill_area (area: like quartet; count, a_bitmap, bit_count, part_mask: INTEGER)
		-- fill `area' from `bitmap' parts of bit size `bit_count'
		require
			valid_count: area.valid_index (count - 1)
		local
			i, bitmap: INTEGER
		do
			bitmap := a_bitmap
			from i := count - 1 until i < 0 loop
				area [i] := bitmap & part_mask
				bitmap := bitmap |>> bit_count
				i := i - 1
			end
		end

	new_area_bitmap (area: like quartet; shift_count: INTEGER): INTEGER
		local
			i, count: INTEGER
		do
			count := area.count
			from i := 0 until i = count loop
				Result := (Result |<< shift_count) | area [i]
				i := i + 1
			end
		end

feature {NONE} -- Internal attributes

	quartet: SPECIAL [INTEGER]
		-- 4 encoded characters to be written

	triplet: SPECIAL [INTEGER]
		-- 3 characters to be encoded

feature {NONE} -- Constants

	Padding_code: INTEGER = 64
		-- character ('=')

end