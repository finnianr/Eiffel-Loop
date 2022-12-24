note
	description: "Multi-bit set and get routines for [$source NATURAL_32] numbers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-24 19:00:46 GMT (Saturday 24th December 2022)"
	revision: "1"

expanded class
	EL_NATURAL_32_BIT_ROUTINES

inherit
	PLATFORM
		export
			{NONE} all
		end

feature -- Access

	combined (combined_values, mask, value: NATURAL_32): NATURAL_32
		-- `combined_values' with `value' set in the `mask' position
		require
			valid_mask: valid_mask (mask)
			valid_value: valid_value (mask, value)
		do
			Result := combined_values & mask.bit_not
			Result := Result | (value |<< shift_count (mask))
		ensure
			value_inserted: isolated (Result, mask) = value
		end

	isolated (combined_values, mask: NATURAL_32): NATURAL_32
		-- value isolated from `combined_values' by mask
		require
			valid_mask: valid_mask (mask)
		do
			Result := (combined_values & mask) |>> shift_count (mask)
		end

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

feature -- Contract Support

	filled_bits (bit_count: INTEGER): NATURAL_32
		local
			i: INTEGER; moving_bit: NATURAL_32
		do
			moving_bit := One
			from i := 1 until i > bit_count loop
				Result := Result | moving_bit
				moving_bit := moving_bit |<< 1
				i := i + 1
			end
		end

	leading_digit_position (bitmap: NATURAL_32): INTEGER
		-- position of first binary digit 1 in `bitmap' going from high to low
		-- zero if none
		local
			moving_bit: NATURAL_32
		do
			moving_bit := One |<< (Natural_32_bits - 1)

			from Result := Natural_32_bits until (moving_bit & bitmap).to_boolean or Result = 0 loop
				moving_bit := moving_bit |>> 1
				Result := Result - 1
			end
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

	valid_value (mask, value: NATURAL_32): BOOLEAN
		-- `True' if `value' is small enough to fit inside `mask' when shifted to same position
		do
			Result := value <= mask |>> shift_count (mask)
		end

feature {NONE} -- Constants

	Eight_ones: NATURAL_32 = 0xFF

	One: NATURAL_32 = 1
end