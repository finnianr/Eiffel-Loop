note
	description: "Multi-bit set and get routines for [$source INTEGER_32] numbers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-30 19:52:53 GMT (Monday 30th January 2023)"
	revision: "3"

expanded class
	EL_INTEGER_32_BIT_ROUTINES

inherit
	EL_INTEGER_BIT_ROUTINES

feature -- Access

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
		local
			l_mask: INTEGER_32
		do
			if mask.to_boolean then
				l_mask := mask |>> Integer_16_bits
				if l_mask >= mask then
					Result := Integer_16_bits
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