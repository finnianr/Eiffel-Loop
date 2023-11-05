note
	description: "Unix implemenation of [$source EL_BIT_ROUTINES_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 14:55:32 GMT (Sunday 5th November 2023)"
	revision: "5"

expanded class
	EL_BIT_ROUTINES

inherit
	EL_BIT_ROUTINES_I

	EL_EXPANDED_ROUTINES

	EL_UNIX_IMPLEMENTATION

feature -- Measurement

	frozen leading_zeros_count_32 (n: NATURAL_32): INTEGER
		-- gcc Built-in Function: int ____builtin_clz (unsigned int x)
		external
			"C (unsigned int): EIF_INTEGER"
		alias
			"__builtin_clz"
		end

	frozen leading_zeros_count_64 (n: NATURAL_64): INTEGER
		-- gcc Built-in Function: int ____builtin_clzll (unsigned long long)
		external
			"C (unsigned long long): EIF_INTEGER"
		alias
			"__builtin_clzll"
		end

	frozen ones_count_32 (n: NATURAL_32): INTEGER
		-- gcc int __builtin_popcount (unsigned int x)
		-- Returns the number of 1-bits in x.
		external
			"C (unsigned int): EIF_INTEGER"
		alias
			"__builtin_popcount"
		end

	frozen ones_count_64 (n: NATURAL_64): INTEGER
		-- gcc int __builtin_popcountll (unsigned long long x)
		-- Returns the number of 1-bits in x.
		external
			"C (unsigned long long): EIF_INTEGER"
		alias
			"__builtin_popcountll"
		end

	frozen trailing_zeros_count_32 (n: NATURAL_32): INTEGER
		-- gcc Built-in Function: int __builtin_ctz (unsigned int x)
		external
			"C (unsigned int): EIF_INTEGER"
		alias
			"__builtin_ctz"
		end

	frozen trailing_zeros_count_64 (n: NATURAL_64): INTEGER
		-- gcc Built-in Function: int __builtin_clzll (unsigned long long)
		external
			"C (unsigned long long): EIF_INTEGER"
		alias
			"__builtin_ctzll"
		end
end