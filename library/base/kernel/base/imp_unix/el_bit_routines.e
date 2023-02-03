note
	description: "Unix implemenation of [$source EL_BIT_ROUTINES_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-03 14:22:30 GMT (Friday 3rd February 2023)"
	revision: "2"

expanded class
	EL_BIT_ROUTINES

inherit
	EL_BIT_ROUTINES_I

	EL_EXPANDED_ROUTINES

	EL_OS_IMPLEMENTATION

feature -- Measurement

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