note
	description: "Bit routines that have a built-in compiler implementation ${EL_BIT_ROUTINES}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-15 10:12:55 GMT (Monday 15th January 2024)"
	revision: "12"

deferred class
	EL_BIT_ROUTINES_I

inherit
	EL_OS_DEPENDENT

feature -- Access

	extended_hash (previous_value, value: INTEGER): INTEGER
		-- combine `previous_value' with `value' so the result does not exceed 2^31
		do
			Result := ((previous_value \\ Magic_number) |<< 8) + value
		end

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

feature -- Constants

	Magic_number: INTEGER = 8388593
		-- Greatest prime lower than 2^23 so that this magic number
		-- shifted to the left does not exceed 2^31.

end