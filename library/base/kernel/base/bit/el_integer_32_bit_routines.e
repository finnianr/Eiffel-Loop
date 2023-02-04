note
	description: "Multi-bit set and get routines for [$source INTEGER_32] numbers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-04 14:37:25 GMT (Saturday 4th February 2023)"
	revision: "9"

expanded class
	EL_INTEGER_32_BIT_ROUTINES

inherit
	EL_INTEGER_BIT_ROUTINES
		rename
			Integer_32_bits as Bit_count
		end

feature -- Access

	filled_bits (n: INTEGER): INTEGER_32
		-- number with `n' bits set to 1 starting from LSB
		local
			natural: NATURAL_32
		do
			natural := natural.bit_not |>> (Bit_count - n)
			Result := natural.to_integer_32
		end

	inserted (combined_values, mask, value: INTEGER_32): INTEGER_32
		-- `combined_values' with `value' set in the `mask' position
		do
			Result := combined_values & mask.bit_not | (value |<< shift_count (mask))
		end

	isolated (combined_values, mask: INTEGER_32): INTEGER_32
		-- value isolated from `combined_values' by mask
		do
			Result := (combined_values & mask) |>> shift_count (mask)
		end

feature -- Measurement

	mask_count (bitmap: INTEGER_32): INTEGER
		-- count of digits in mask (assuming all ones)
		local
			b: EL_BIT_ROUTINES; n: NATURAL_32
		do
			if bitmap.to_boolean then
				n := bitmap.to_natural_32
				Result := bit_count - b.leading_zeros_count_32 (n) - b.trailing_zeros_count_32 (n)
			end
		end

	shift_count (mask: INTEGER_32): INTEGER
		-- count of trailing zeros in binary number
		local
			b: EL_BIT_ROUTINES
		do
			if mask.to_boolean then
				Result := b.trailing_zeros_count_32 (mask.to_natural_32)
			end
		end

feature -- Contract Support

	compatible_value (mask, value: INTEGER_32): BOOLEAN
		-- `True' if `value' is small enough to fit inside `mask' when shifted to the same position
		do
			Result := value <= mask |>> shift_count (mask)
		end

	is_positive (v: INTEGER_32): BOOLEAN
		do
			Result := v >= v.zero
		end

	right_justified (mask: INTEGER_32): INTEGER_32
		-- mask right shifted until LSB is in position 0
		do
			Result := mask |>> shift_count (mask)
		end

	valid_mask (mask: INTEGER_32): BOOLEAN
		-- `True' if mask consists of continuous ones
		do
			if mask.to_boolean then
				Result := right_justified (mask) = filled_bits (mask_count (mask))
			end
		end

feature {NONE} -- Constants

	One: INTEGER_32 = 1

end