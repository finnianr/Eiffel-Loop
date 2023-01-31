note
	description: "Multi-bit set and get routines for [$source INTEGER_32] numbers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-31 14:11:17 GMT (Tuesday 31st January 2023)"
	revision: "5"

expanded class
	EL_INTEGER_32_BIT_ROUTINES

inherit
	EL_INTEGER_BIT_ROUTINES
		rename
			bit_count as Integer_32_bits
		end

feature -- Access

	filled_bits (bit_count: INTEGER): INTEGER_32
		-- number with `bit_count' bits set to 1 starting from LSB
		local
			natural: NATURAL_32
		do
			natural := natural.bit_not |>> (Integer_32_bits - bit_count)
			Result := natural.to_integer_32
		end

	inserted (combined_values, mask, value: INTEGER_32): INTEGER_32
		-- `combined_values' with `value' set in the `mask' position
		do
			Result := combined_values & mask.bit_not
			Result := Result | (value |<< shift_count (mask))
		end

	isolated (combined_values, mask: INTEGER_32): INTEGER_32
		-- value isolated from `combined_values' by mask
		do
			Result := (combined_values & mask) |>> shift_count (mask)
		end

feature -- Measurement

	leading_digit_position (bitmap: INTEGER_32): INTEGER
		-- position of first binary digit 1 in `bitmap' going from high to low
		-- zero if none
		do
			from
				Result := Integer_32_bits
			until (One |<< (Result - 1) & bitmap).to_boolean or Result = 0 loop
				Result := Result - 1
			end
		end

	shift_count (mask: INTEGER_32): INTEGER
		-- Use https://stackoverflow.com/questions/31601190/given-a-bit-mask-how-to-compute-bit-shift-count
		local
			l_mask: INTEGER_32
		do
			Result := 32
			l_mask := mask & (mask.bit_not + 1)
			if l_mask.to_boolean then
				Result := Result - 1
			end
			if (l_mask & 0x0000FFFF).to_boolean then
				Result := Result - 16
			end
			if (l_mask & 0x00FF00FF).to_boolean then
				Result := Result - 8
			end
			if (l_mask & 0x0F0F0F0F).to_boolean then
				Result := Result - 4
			end
			if (l_mask & 0x33333333).to_boolean then
				Result := Result - 2
			end
			if (l_mask & 0x55555555).to_boolean then
				Result := Result - 1
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

	valid_mask (mask: INTEGER_32): BOOLEAN
		-- `True' if mask consists of continuous ones
		local
			adjusted_mask: INTEGER_32
		do
			if mask.to_boolean then
				adjusted_mask := mask |>> shift_count (mask)
				Result := adjusted_mask = filled_bits (leading_digit_position (adjusted_mask))
			end
		end

feature {NONE} -- Constants

	One: INTEGER_32 = 1

end