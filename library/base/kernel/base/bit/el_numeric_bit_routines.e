note
	description: "Multi-bit set and get routines for types conforming to [$source NUMERIC]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-01 9:59:02 GMT (Wednesday 1st February 2023)"
	revision: "6"

deferred class
	EL_NUMERIC_BIT_ROUTINES

inherit
	PLATFORM
		export
			{NONE} all
		end

feature -- Access

	bit_count: INTEGER
		-- number of bits in number
		deferred
		end

	filled_bits (n: INTEGER): like one
		-- number with `bit_count' bits set to 1 starting from LSB
		require
			valid_bit_count: n <= bit_count
		deferred
		end

	inserted (combined_values, mask, value: like one): like one
		-- `combined_values' with `value' inserted at the `mask' position
		require
			valid_mask: valid_mask (mask)
			compatible_value: compatible_value (mask, value)
		deferred
		ensure
			value_inserted: isolated (Result, mask) = value
		end

	isolated (combined_values, mask: like one): like one
		-- value isolated from `combined_values' by mask
		require
			valid_mask: valid_mask (mask)
		deferred
		end

feature -- Contract Support

	compatible_value (mask, value: like one): BOOLEAN
		-- `True' if `value' is small enough to fit inside `mask' when shifted to the same position
		deferred
		end

	valid_mask (mask: like one): BOOLEAN
		-- `True' if mask consists of continuous ones
		deferred
		end

feature {NONE} -- Implemenation

	one: NUMERIC
		deferred
		end
end