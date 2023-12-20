note
	description: "Multi-bit set and get routines for [$source NATURAL_32] numbers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-05 9:15:32 GMT (Thursday 5th October 2023)"
	revision: "11"

expanded class
	EL_NATURAL_32_BIT_ROUTINES

inherit
	EL_NUMERIC_BIT_ROUTINES

	EL_32_BIT_IMPLEMENTATION

feature -- Access

	inserted (combined_values, mask, value: NATURAL_32): NATURAL_32
		-- `combined_values' with `value' inserted at the `mask' position
		do
			Result := combined_values & mask.bit_not | (value |<< shift_count (mask))
		end

	filled_bits (n: INTEGER): NATURAL_32
		-- number with `bit_count' bits set to 1 starting from LSB
		do
			Result := Result.bit_not |>> (bit_count - n)
		end

	isolated (combined_values, mask: NATURAL_32): NATURAL_32
		-- value isolated from `combined_values' by mask
		do
			Result := (combined_values & mask) |>> shift_count (mask)
		end

feature -- Measurement

	mask_count (bitmap: NATURAL_32): INTEGER
		-- count of digits in mask (assuming all ones)
		local
			b: EL_BIT_ROUTINES
		do
			if bitmap.to_boolean then
				Result := 64 - b.leading_zeros_count_64 (bitmap) - b.trailing_zeros_count_64 (bitmap)
			end
		end

	shift_count (mask: NATURAL_32): INTEGER
		-- Use built-in compiler routines
		local
			b: EL_BIT_ROUTINES
		do
			if mask.to_boolean then
				Result := b.trailing_zeros_count_32 (mask)
			end
		end

feature -- Contract Support

	compatible_value (mask, value: NATURAL_32): BOOLEAN
		-- `True' if `value' is small enough to fit inside `mask' when shifted to the same position
		do
			Result := value <= mask |>> shift_count (mask)
		end

	right_justified (mask: NATURAL_32): NATURAL_32
		-- mask right shifted until LSB is in position 0
		do
			Result := mask |>> shift_count (mask)
		end

	valid_mask (mask: NATURAL_32): BOOLEAN
		-- `True' if mask consists of continuous ones
		do
			if mask.to_boolean then
				Result := right_justified (mask) = filled_bits (mask_count (mask))
			end
		end

feature {NONE} -- Constants

	One: NATURAL_32 = 1

end