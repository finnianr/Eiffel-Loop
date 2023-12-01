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
	date: "2023-12-01 9:50:24 GMT (Friday 1st December 2023)"
	revision: "7"

expanded class
	EL_BIT_ROUTINES

inherit
	EL_BIT_ROUTINES_I

	EL_EXPANDED_ROUTINES

	EL_WINDOWS_IMPLEMENTATION

feature -- Measurement

	frozen leading_zeros_count_32 (n: NATURAL_32): INTEGER
		-- leading zero count compatible with gcc function: int ____builtin_clz (unsigned int x)
		external
			"C inline use <intrin.h>"
		alias
			"[
				{ 
					unsigned long index, mask = (unsigned long)$n;
					_BitScanReverse (&index, mask);
					return (EIF_NATURAL_32)(31 - index);
				}
			]"
		end

	frozen leading_zeros_count_64 (n: NATURAL_64): INTEGER
		-- leading zero count compatible with gcc function: int ____builtin_clzll (unsigned long long)
		external
			"C inline use <intrin.h>"
		alias
			"[
				{ 
					unsigned long index;
					__int64 mask = (__int64)$n;
					_BitScanReverse64 (&index, mask);
					return (EIF_NATURAL_32)(63 - index);
				}
			]"
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

	frozen trailing_zeros_count_32 (n: NATURAL_32): INTEGER
		-- trailing zero count compatible with gcc function: int __builtin_ctz (unsigned int x)
		external
			"C inline use <intrin.h>"
		alias
			"[
				{ 
					unsigned long index, mask = (unsigned long)$n;
					_BitScanForward (&index, mask);
					return (EIF_NATURAL_32)index;
				}
			]"
		end

	frozen trailing_zeros_count_64 (n: NATURAL_64): INTEGER
		-- trailing zero count compatible with gcc function: int __builtin_clzll (unsigned long long)
		external
			"C inline use <intrin.h>"
		alias
			"[
				{ 
					unsigned long index;
					__int64 mask = (__int64)$n;
					_BitScanForward64 (&index, mask);
					return (EIF_NATURAL_32)index;
				}
			]"
		end

	zero_or_one (n: NATURAL_32): NATURAL_32
		-- 1 if `n > 0' or else 0
		external
			"C inline use <intrin.h>"
		alias
			"[
				{ 
					unsigned long index, mask = (unsigned long)$n;
					_BitScanReverse (&index, mask);
					return (EIF_NATURAL_32)(mask >> index);
				}
			]"
		end

end