note
	description: "Bit routines that have a built-in compiler implementation [$source EL_BIT_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-03 13:04:27 GMT (Friday 3rd February 2023)"
	revision: "4"

deferred class
	EL_BIT_ROUTINES_I

feature -- Measurement

	trailing_zeros_count_32 (x: NATURAL_32): INTEGER
		-- number of trailing zeros after LSB
		deferred
		end

	trailing_zeros_count_64 (x: NATURAL_64): INTEGER
		-- number of trailing zeros after LSB
		deferred
		end

end