note
	description: "Conversion of binary, octal or hexadecimal numeric strings to numbers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-01 17:08:29 GMT (Thursday 1st December 2022)"
	revision: "4"

deferred class
	EL_POWER_2_BASE_NUMERIC_STRING_CONVERSION

feature -- Substring conversion

	substring_to_integer (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): INTEGER
		do
			Result := substring_to_natural_64 (str, start_index, end_index).to_integer_32
		end

	substring_to_integer_16 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): INTEGER_16
		do
			Result := substring_to_natural_64 (str, start_index, end_index).to_integer_16
		end

	substring_to_integer_64 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): INTEGER_64
		do
			Result := substring_to_natural_64 (str, start_index, end_index).to_integer_64
		end

	substring_to_natural_16 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): NATURAL_16
		do
			Result := substring_to_natural_64 (str, start_index, end_index).to_natural_16
		end

	substring_to_natural_32 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): NATURAL
		do
			Result := substring_to_natural_64 (str, start_index, end_index).to_natural_32
		end

	substring_to_natural_64 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): NATURAL_64
		require
			valid_sequence: is_valid_sequence (str, start_index, end_index)
			--
		local
			i, count, bit_shift: INTEGER; value: NATURAL_64; found: BOOLEAN
		do
			count := end_index - start_index + 1
			-- Skip 0x00
			from i := start_index until found or i > end_index loop
				if is_leading_digit (str, i) then
					i := i + 1
				else
					found := True
				end
			end
			from until i > end_index loop
				value := to_decimal (str [i]).to_natural_64
				bit_shift := (end_index - i) * bit_count
				Result := Result | (value |<< bit_shift)
				i := i + 1
			end
		end

feature -- Conversion

	to_decimal (uc: CHARACTER_32): INTEGER_64
		do
			inspect uc
				when '0' .. '9' then
				 	 Result := (uc |-| '0')
				when 'a' .. 'z' then
				 	 Result := (uc |-| 'a') + 10
				when 'A' .. 'Z' then
				 	 Result := (uc |-| 'A') + 10
			else
			end
		end

	to_integer (str: READABLE_STRING_GENERAL): INTEGER
			--
		do
			Result := substring_to_integer (str, 1, str.count)
		end

	to_integer_16 (str: READABLE_STRING_GENERAL): INTEGER_16
			--
		do
			Result := substring_to_integer_16 (str, 1, str.count)
		end

	to_integer_64 (str: READABLE_STRING_GENERAL): INTEGER_64
			--
		do
			Result := substring_to_integer_64 (str, 1, str.count)
		end

	to_natural_16 (str: READABLE_STRING_GENERAL): NATURAL_16
			--
		do
			Result := substring_to_natural_16 (str, 1, str.count)
		end

	to_natural_32 (str: READABLE_STRING_GENERAL): NATURAL
			--
		do
			Result := substring_to_natural_32 (str, 1, str.count)
		end

	to_natural_64 (str: READABLE_STRING_GENERAL): NATURAL_64
		do
			Result := substring_to_natural_64 (str, 1, str.count)
		end

feature -- Contract Support

	is_valid_sequence (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): BOOLEAN
		local
			i: INTEGER
		do
			Result := True
			from i := start_index until not Result or i > end_index loop
				Result := is_valid_digit (str, i)
				i := i + 1
			end
		end

feature -- Access

	bit_count: INTEGER
		-- number of bits to encode single binary, octal or hexadecimal digit
		deferred
		end

feature {NONE} -- Implementation

	is_leading_digit (str: READABLE_STRING_GENERAL; index: INTEGER): BOOLEAN
		deferred
		end

	is_valid_digit (str: READABLE_STRING_GENERAL; index: INTEGER): BOOLEAN
		deferred
		end

end