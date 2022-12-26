note
	description: "Multi-bit set and get routines for [$source NATURAL_32] numbers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-26 16:05:05 GMT (Monday 26th December 2022)"
	revision: "2"

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

	shift_count (mask: NATURAL_32): INTEGER
		local
			byte_position: INTEGER
		do
			if mask.to_boolean then
--				find first byte block overlapping mask
				from until (mask & (Eight_ones |<< byte_position)).to_boolean loop
					byte_position := byte_position + 8
				end
--				search within byte block starting at `byte_position'
				from Result := byte_position until (mask | (One |<< Result)) = mask loop
					Result := Result + 1
				end
			end
		end

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

	Eight_ones: NATURAL_32 = 0xFF

	One: NATURAL_32 = 1
end