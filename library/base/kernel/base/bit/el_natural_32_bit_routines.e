note
	description: "Multi-bit set and get routines for [$source NATURAL_32] numbers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-01 9:39:22 GMT (Wednesday 1st February 2023)"
	revision: "6"

expanded class
	EL_NATURAL_32_BIT_ROUTINES

inherit
	EL_NUMERIC_BIT_ROUTINES
		rename
			Natural_32_bits as bit_count
		end

feature -- Access

	inserted (combined_values, mask, value: NATURAL_32): NATURAL_32
		-- `combined_values' with `value' inserted at the `mask' position
		do
			Result := combined_values & mask.bit_not
			Result := Result | (value |<< shift_count (mask))
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

	leading_digit_position (bitmap: NATURAL_32): INTEGER
		-- position of first binary digit 1 in `bitmap' going from high to low
		-- zero if none
		do
			from
				Result := bit_count
			until (One |<< (Result - 1) & bitmap).to_boolean or Result = 0 loop
				Result := Result - 1
			end
		end

	shift_count (mask: NATURAL_32): INTEGER
		-- Use https://stackoverflow.com/questions/31601190/given-a-bit-mask-how-to-compute-bit-shift-count
		local
			l_mask: NATURAL_32
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

	compatible_value (mask, value: NATURAL_32): BOOLEAN
		-- `True' if `value' is small enough to fit inside `mask' when shifted to the same position
		do
			Result := value <= mask |>> shift_count (mask)
		end

	valid_mask (mask: NATURAL_32): BOOLEAN
		-- `True' if mask consists of continuous ones
		local
			adjusted_mask: NATURAL_32
		do
			if mask.to_boolean then
				adjusted_mask := mask |>> shift_count (mask)
				Result := adjusted_mask = filled_bits (leading_digit_position (adjusted_mask))
			end
		end

feature {NONE} -- Constants

	One: NATURAL_32 = 1

end