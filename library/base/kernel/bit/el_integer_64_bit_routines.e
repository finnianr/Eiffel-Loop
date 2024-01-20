note
	description: "Multi-bit set and get routines for ${INTEGER_64} numbers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "12"

expanded class
	EL_INTEGER_64_BIT_ROUTINES

inherit
	EL_INTEGER_BIT_ROUTINES

	EL_64_BIT_IMPLEMENTATION

feature -- Access

	inserted (combined_values, mask, value: INTEGER_64): INTEGER_64
		-- `combined_values' with `value' inserted at the `mask' position
		do
			Result := combined_values & mask.bit_not | (value |<< shift_count (mask))
		end

	filled_bits (n: INTEGER): INTEGER_64
		-- number with `bit_count' bits set to 1 starting from LSB
		local
			natural: NATURAL_64
		do
			natural := natural.bit_not |>> (Bit_count - n)
			Result := natural.to_integer_64
		end

	isolated (combined_values, mask: INTEGER_64): INTEGER_64
		-- value isolated from `combined_values' by mask
		do
			Result := (combined_values & mask) |>> shift_count (mask)
		end

	right_justified (mask: INTEGER_64): INTEGER_64
		-- mask right shifted until LSB is in position 0
		do
			Result := mask |>> shift_count (mask)
		end

feature -- Measurement

	mask_count (bitmap: INTEGER_64): INTEGER
		-- count of digits in mask (assuming all ones)
		local
			b: EL_BIT_ROUTINES; n: NATURAL_64
		do
			if bitmap.to_boolean then
				n := bitmap.to_natural_64
				Result := 64 - b.leading_zeros_count_64 (n) - b.trailing_zeros_count_64 (n)
			end
		end

	shift_count (mask: INTEGER_64): INTEGER
		-- Use built-in compiler routines
		local
			b: EL_BIT_ROUTINES
		do
			if mask.to_boolean then
				Result := b.trailing_zeros_count_64 (mask.to_natural_64)
			end
		end

feature -- Contract Support

	compatible_value (mask, value: INTEGER_64): BOOLEAN
		-- `True' if `value' is small enough to fit inside `mask' when shifted to the same position
		do
			Result := value <= mask |>> shift_count (mask)
		end

	is_positive (v: INTEGER_64): BOOLEAN
		do
			Result := v >= v.zero
		end

	valid_mask (mask: INTEGER_64): BOOLEAN
		-- `True' if mask consists of continuous ones
		do
			if mask.to_boolean then
				Result := right_justified (mask) = filled_bits (mask_count (mask))
			end
		end

feature {NONE} -- Constants

	One: INTEGER_64 = 1

end