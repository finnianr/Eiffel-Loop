note
	description: "Multi-bit set and get routines for [$source NATURAL_32] numbers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-30 17:55:49 GMT (Monday 30th January 2023)"
	revision: "3"

expanded class
	EL_NATURAL_32_BIT_ROUTINES

inherit
	EL_NUMERIC_BIT_ROUTINES

feature -- Access

	inserted (combined_values, mask, value: NATURAL_32): NATURAL_32
		-- `combined_values' with `value' inserted at the `mask' position
		do
			Result := combined_values & mask.bit_not
			Result := Result | (value |<< shift_count (mask))
		end

	filled_bits (bit_count: INTEGER): NATURAL_32
		-- number with `bit_count' bits set to 1 starting from LSB
		local
			i: INTEGER
		do
			from i := 0 until i = bit_count loop
				Result := Result | (One |<< i)
				i := i + 1
			end
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
				Result := Natural_32_bits
			until (One |<< (Result - 1) & bitmap).to_boolean or Result = 0 loop
				Result := Result - 1
			end
		end

	shift_count (mask: NATURAL_32): INTEGER
		local
			l_mask: NATURAL_32
		do
			if mask.to_boolean then
				l_mask := mask |>> Natural_16_bits
				if l_mask >= mask then
					Result := Natural_16_bits
				else
					l_mask := mask
				end
				from until (l_mask & One).to_boolean loop
					l_mask := l_mask |>> 1
					Result := Result + 1
				end
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