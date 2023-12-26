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
	date: "2023-12-25 14:57:54 GMT (Monday 25th December 2023)"
	revision: "9"

expanded class
	EL_BIT_ROUTINES

inherit
	EL_BIT_ROUTINES_I

	EL_EXPANDED_ROUTINES

	EL_BIT_POPULATION_ROUTINES
		rename
			precomputed_ones_count_32 as ones_count_32,
			precomputed_ones_count_64 as ones_count_64
		end

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