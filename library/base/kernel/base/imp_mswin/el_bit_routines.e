note
	description: "Windows implemenation of [$source EL_BIT_ROUTINES_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-03 13:58:10 GMT (Friday 3rd February 2023)"
	revision: "1"

expanded class
	EL_BIT_ROUTINES

inherit
	EL_BIT_ROUTINES_I

	EL_EXPANDED_ROUTINES

	EL_OS_IMPLEMENTATION

feature -- Measurement

	frozen trailing_zeros_count_32 (mask: NATURAL_32): INTEGER
		do
			get_trailing_zeros_count_32 ($Result, mask)
		end

	frozen trailing_zeros_count_64 (mask: NATURAL_64): INTEGER
		do
			get_trailing_zeros_count_64 ($Result, mask)
		end

feature {NONE} -- C externals

	frozen get_trailing_zeros_count_32 (index_ptr: POINTER; mask: NATURAL_32)
		-- unsigned char __BitScanForward(unsigned long * Index, unsigned long Mask);
		-- Search the mask data from least significant bit (LSB) to the most significant bit (MSB) for a set bit (1).
		external
			"C (unsigned long*, unsigned long) | <intrin.h>"
		alias
			"_BitScanForward"
		end

	frozen get_trailing_zeros_count_64 (index_ptr: POINTER; mask: NATURAL_64)
		-- unsigned char _BitScanForward64(unsigned long * Index, unsigned __int64 Mask);
		-- Search the mask data from least significant bit (LSB) to the most significant bit (MSB) for a set bit (1).
		external
			"C (unsigned long*, unsigned __int64) | <intrin.h>"
		alias
			"_BitScanForward64"
		end

end