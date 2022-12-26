note
	description: "Multi-bit set and get routines for [$source INTEGER_32] numbers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-26 16:06:04 GMT (Monday 26th December 2022)"
	revision: "2"

expanded class
	EL_INTEGER_32_BIT_ROUTINES

inherit
	EL_INTEGER_BIT_ROUTINES

feature -- Access

	inserted (combined_values, mask, value: INTEGER_32): INTEGER_32
		-- `combined_values' with `value' set in the `mask' position
		do
			Result := combined_values & mask.bit_not
			Result := Result | (value |<< shift_count (mask))
		end

	filled_bits (bit_count: INTEGER): INTEGER_32
		-- number with `bit_count' bits set to 1 starting from LSB
		local
			i: INTEGER
		do
			from i := 0 until i = bit_count loop
				Result := Result | (One |<< i)
				i := i + 1
			end
		end

	isolated (combined_values, mask: INTEGER_32): INTEGER_32
		-- value isolated from `combined_values' by mask
		do
			Result := (combined_values & mask) |>> shift_count (mask)
		end

feature -- Measurement

	shift_count (mask: INTEGER_32): INTEGER
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

	Eight_ones: INTEGER_32 = 0xFF

	One: INTEGER_32 = 1
end