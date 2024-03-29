note
	description: "Multi-bit set and get routines for ${NATURAL_64} numbers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "12"

expanded class
	EL_NATURAL_64_BIT_ROUTINES

inherit
	EL_NUMERIC_BIT_ROUTINES

	EL_64_BIT_IMPLEMENTATION

feature -- Access

	inserted (combined_values, mask, value: NATURAL_64): NATURAL_64
		-- `combined_values' with `value' inserted at the `mask' position
		do
			Result := combined_values & mask.bit_not | (value |<< shift_count (mask))
		end

	filled_bits (n: INTEGER): NATURAL_64
		-- number with `bit_count' bits set to 1 starting from LSB
		do
			Result := Result.bit_not |>> (bit_count - n)
		end

	isolated (combined_values, mask: NATURAL_64): NATURAL_64
		-- value isolated from `combined_values' by mask
		do
			Result := (combined_values & mask) |>> shift_count (mask)
		end

feature -- Measurement

	mask_count (bitmap: NATURAL_64): INTEGER
		-- count of digits in mask (assuming all ones)
		local
			b: EL_BIT_ROUTINES
		do
			if bitmap.to_boolean then
				Result := 64 - b.leading_zeros_count_64 (bitmap) - b.trailing_zeros_count_64 (bitmap)
			end
		end

	shift_count (mask: NATURAL_64): INTEGER
		-- Use built-in compiler routines
		local
			b: EL_BIT_ROUTINES
		do
			if mask.to_boolean then
				Result := b.trailing_zeros_count_64 (mask)
			end
		end

feature -- Contract Support

	compatible_value (mask, value: NATURAL_64): BOOLEAN
		-- `True' if `value' is small enough to fit inside `mask' when shifted to the same position
		do
			Result := value <= mask |>> shift_count (mask)
		end

	right_justified (mask: NATURAL_64): NATURAL_64
		-- mask right shifted until LSB is in position 0
		do
			Result := mask |>> shift_count (mask)
		end

	valid_mask (mask: NATURAL_64): BOOLEAN
		-- `True' if mask consists of continuous ones
		do
			if mask.to_boolean then
				Result := right_justified (mask) = filled_bits (mask_count (mask))
			end
		end

feature {NONE} -- Constants

	One: NATURAL_64 = 1

end