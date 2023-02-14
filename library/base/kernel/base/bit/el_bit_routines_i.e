note
	description: "Bit routines that have a built-in compiler implementation [$source EL_BIT_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-14 7:43:11 GMT (Tuesday 14th February 2023)"
	revision: "6"

deferred class
	EL_BIT_ROUTINES_I

feature -- Measurement

	leading_zeros_count_32 (n: NATURAL_32): INTEGER
		-- number of trailing zeros before MSB
		deferred
		end

	leading_zeros_count_64 (n: NATURAL_64): INTEGER
		-- number of trailing zeros before MSB
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

	trailing_zeros_count_32 (x: NATURAL_32): INTEGER
		-- number of trailing zeros after LSB
		deferred
		end

	trailing_zeros_count_64 (x: NATURAL_64): INTEGER
		-- number of trailing zeros after LSB
		deferred
		end

end