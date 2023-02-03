note
	description: "Multi-bit set and get routines for [$source NATURAL_64] numbers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-03 13:11:15 GMT (Friday 3rd February 2023)"
	revision: "7"

expanded class
	EL_NATURAL_64_BIT_ROUTINES

inherit
	EL_NUMERIC_BIT_ROUTINES
		rename
			Natural_64_bits as bit_count
		end

feature -- Access

	inserted (combined_values, mask, value: NATURAL_64): NATURAL_64
		-- `combined_values' with `value' inserted at the `mask' position
		do
			Result := combined_values & mask.bit_not
			Result := Result | (value |<< shift_count (mask))
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

	leading_digit_position (bitmap: NATURAL_64): INTEGER
		-- position of first binary digit 1 in `bitmap' going from high to low
		-- zero if none
		do
			from
				Result := bit_count
			until (One |<< (Result - 1) & bitmap).to_boolean or Result = 0 loop
				Result := Result - 1
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

	valid_mask (mask: NATURAL_64): BOOLEAN
		-- `True' if mask consists of continuous ones
		local
			adjusted_mask: NATURAL_64
		do
			if mask.to_boolean then
				adjusted_mask := mask |>> shift_count (mask)
				Result := adjusted_mask = filled_bits (leading_digit_position (adjusted_mask))
			end
		end

feature {NONE} -- Constants

	One: NATURAL_64 = 1

end