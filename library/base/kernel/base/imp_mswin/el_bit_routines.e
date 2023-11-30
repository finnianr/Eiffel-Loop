note
	description: "Windows implemenation of [$source EL_BIT_ROUTINES_I] interface"
	notes: "[
		Cannot use _popcnt on MS VC compiler because it says in manual:
		
		"If you run code that uses these intrinsics on hardware that doesn't support the popcnt instruction,
		the results are unpredictable."
		
		So instead we use a workaround using bit-scan functions from `<intrin.h>'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-30 9:18:23 GMT (Thursday 30th November 2023)"
	revision: "6"

expanded class
	EL_BIT_ROUTINES

inherit
	EL_BIT_ROUTINES_I

	EL_EXPANDED_ROUTINES

	EL_WINDOWS_IMPLEMENTATION

feature -- Measurement

	frozen leading_zeros_count_32 (mask: NATURAL_32): INTEGER
		local
			pos: INTEGER
		do
			c_bit_scan_reverse_32 ($pos, mask)
			Result := 31 - pos -- make compatible with gcc result
		end

	frozen leading_zeros_count_64 (mask: NATURAL_64): INTEGER
		local
			pos: INTEGER
		do
			c_bit_scan_reverse_64 ($pos, mask)
			Result := 63 - pos -- make compatible with gcc result
		end

	frozen ones_count_32 (a_bitmap: NATURAL_32): INTEGER
		-- count of 1's in `bitmap'
		local
			leading_count, trailing_count, zero_count: INTEGER; skip_ones: BOOLEAN
			bitmap: NATURAL_32
		do
			if a_bitmap.to_boolean then
				leading_count := leading_zeros_count_32 (a_bitmap)
				trailing_count := trailing_zeros_count_32 (a_bitmap)
				Result := 32 - leading_count - trailing_count
				skip_ones := True
				from bitmap := a_bitmap |>> trailing_count until bitmap = bitmap.zero loop
					if skip_ones then
						zero_count := trailing_zeros_count_32 (bitmap.bit_not) -- skip ones
					else
						zero_count := trailing_zeros_count_32 (bitmap) -- skip zeros
						Result := Result - zero_count
					end
					skip_ones := not skip_ones
					bitmap := bitmap |>> zero_count
				end
			end
		end


	frozen ones_count_64 (a_bitmap: NATURAL_64): INTEGER
		-- count of 1's in `bitmap'
		local
			leading_count, trailing_count, zero_count: INTEGER; skip_ones: BOOLEAN
			bitmap: NATURAL_64
		do
			if a_bitmap.to_boolean then
				leading_count := leading_zeros_count_64 (a_bitmap)
				trailing_count := trailing_zeros_count_64 (a_bitmap)
				Result := 64 - leading_count - trailing_count
				skip_ones := True
				from bitmap := a_bitmap |>> trailing_count until bitmap = bitmap.zero loop
					if skip_ones then
						zero_count := trailing_zeros_count_64 (bitmap.bit_not) -- skip ones
					else
						zero_count := trailing_zeros_count_64 (bitmap) -- skip zeros
						Result := Result - zero_count
					end
					skip_ones := not skip_ones
					bitmap := bitmap |>> zero_count
				end
			end
		end

	frozen trailing_zeros_count_32 (mask: NATURAL_32): INTEGER
		do
			c_bit_scan_forward_count_32 ($Result, mask)
		end

	frozen trailing_zeros_count_64 (mask: NATURAL_64): INTEGER
		do
			c_bit_scan_forward_count_64 ($Result, mask)
		end

feature {NONE} -- C externals

	frozen c_bit_scan_reverse_32 (index_ptr: POINTER; mask: NATURAL_32)
		-- unsigned char __BitScanReverse(unsigned long * Index, unsigned long Mask);
		-- Search the mask data from least significant bit (LSB) to the most significant bit (MSB)
		-- for a set bit (1)
		-- Result is nonzero if any bit was set in Mask, or 0 if no set bits were found.
		external
			"C (unsigned long*, unsigned long) | <intrin.h>"
		alias
			"_BitScanReverse"
		end

	frozen c_bit_scan_reverse_64 (index_ptr: POINTER; mask: NATURAL_64)
		-- unsigned char _BitScanReverse64(unsigned long * Index, unsigned __int64 Mask);
		-- Search the mask data from most significant bit (MSB) to least significant bit (LSB)
		-- for a set bit (1)
		-- Result is nonzero if any bit was set in Mask, or 0 if no set bits were found.
		external
			"C (unsigned long*, unsigned __int64) | <intrin.h>"
		alias
			"_BitScanReverse64"
		end

	frozen c_bit_scan_forward_count_32 (index_ptr: POINTER; mask: NATURAL_32)
		-- unsigned char __BitScanForward(unsigned long * Index, unsigned long Mask);
		-- Search the mask data from most significant bit (MSB) to least significant bit (LSB)
		-- for a set bit (1)
		-- Result is 0 if the mask is zero; nonzero otherwise.
		external
			"C (unsigned long*, unsigned long) | <intrin.h>"
		alias
			"_BitScanForward"
		end

	frozen c_bit_scan_forward_count_64 (index_ptr: POINTER; mask: NATURAL_64)
		-- unsigned char _BitScanForward64(unsigned long * Index, unsigned __int64 Mask);
		-- Search the mask data from least significant bit (LSB) to the most significant bit (MSB)
		-- for a set bit (1)
		-- Result is 0 if the mask is zero; nonzero otherwise.
		external
			"C (unsigned long*, unsigned __int64) | <intrin.h>"
		alias
			"_BitScanForward64"
		end

end