note
	description: "Bit routines that have a built-in compiler implementation [$source EL_BIT_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-25 14:57:15 GMT (Monday 25th December 2023)"
	revision: "11"

deferred class
	EL_BIT_ROUTINES_I

inherit
	EL_OS_DEPENDENT

feature -- Measurement

	leading_zeros_count_32 (n: NATURAL_32): INTEGER
		-- number of trailing zeros before MSB
		-- `n = 0' is undefined on gcc
		require
			not_zero: n /= 0
		deferred
		end

	leading_zeros_count_64 (n: NATURAL_64): INTEGER
		-- number of trailing zeros before MSB
		-- `n = 0' is undefined on gcc
		require
			not_zero: n /= 0
		deferred
		end

	ones_count_32 (a_bitmap: NATURAL_32): INTEGER
		-- count of 1's in `bitmap'
		deferred
		end

	ones_count_64 (a_bitmap: NATURAL_64): INTEGER
		-- count of 1's in `bitmap'
		deferred
		end

	trailing_zeros_count_32 (n: NATURAL_32): INTEGER
		-- number of trailing zeros after LSB
		-- `n = 0' is undefined on gcc
		require
			not_zero: n /= 0
		deferred
		end

	trailing_zeros_count_64 (n: NATURAL_64): INTEGER
		-- number of trailing zeros after LSB
		-- `n = 0' is undefined on gcc
		require
			not_zero: n /= 0
		deferred
		end

	zero_or_one (n: NATURAL_32): NATURAL_32
		-- 1 if `n > 0' or else 0
		deferred
		ensure
			valid_n_gt_zero: n > 0 implies Result = 1
			valid_n_zero: n = 0 implies Result = 0
		end

end