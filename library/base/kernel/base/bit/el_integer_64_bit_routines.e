note
	description: "Multi-bit set and get routines for [$source INTEGER_64] numbers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-03 13:11:49 GMT (Friday 3rd February 2023)"
	revision: "7"

expanded class
	EL_INTEGER_64_BIT_ROUTINES

inherit
	EL_INTEGER_BIT_ROUTINES
		rename
			Integer_64_bits as bit_count
		end

feature -- Access

	inserted (combined_values, mask, value: INTEGER_64): INTEGER_64
		-- `combined_values' with `value' inserted at the `mask' position
		do
			Result := combined_values & mask.bit_not
			Result := Result | (value |<< shift_count (mask))
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

feature -- Measurement

	leading_digit_position (bitmap: INTEGER_64): INTEGER
		-- position of first binary digit 1 in `bitmap' going from high to low
		-- zero if none
		do
			from
				Result := bit_count
			until (One |<< (Result - 1) & bitmap).to_boolean or Result = 0 loop
				Result := Result - 1
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
		local
			adjusted_mask: INTEGER_64
		do
			if mask.to_boolean then
				adjusted_mask := mask |>> shift_count (mask)
				Result := adjusted_mask = filled_bits (leading_digit_position (adjusted_mask))
			end
		end

feature {NONE} -- Constants

	One: INTEGER_64 = 1

end