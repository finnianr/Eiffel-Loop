note
	description: "Convert binary, octal or hexadecimal strings to [$source NUMERIC] types"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-12 16:49:04 GMT (Sunday 12th November 2023)"
	revision: "8"

deferred class
	EL_BASE_POWER_2_CONVERTER

inherit
	ANY

	EL_SHARED_STRING_8_CURSOR

	STRING_HANDLER

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

	substring_to_natural_8 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): NATURAL_8
		do
			Result := substring_to_natural_64 (str, start_index, end_index).to_natural_8
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
			i, bit_shift, offset: INTEGER; value: NATURAL_64; found: BOOLEAN
			l_area: SPECIAL [CHARACTER]
		do
			if attached character_array (str, start_index, end_index) as array then
				offset := array.offset
				l_area := array.area
				-- Skip 0x00
				from i := start_index - 1 until found or i = end_index loop
					if is_leading_digit (l_area [i + offset], i - start_index + 2) then
						i := i + 1
					else
						found := True
					end
				end
				from until i = end_index loop
					value := to_decimal (l_area [i + offset]).to_natural_64
					bit_shift := (end_index - i - 1) * bit_count
					Result := Result | (value |<< bit_shift)
					i := i + 1
				end
			end
		end

feature -- Conversion

	to_decimal (c: CHARACTER): INTEGER_64
		do
			inspect c
				when '0' .. '9' then
				 	 Result := (c |-| '0')
				when 'a' .. 'z' then
				 	 Result := (c |-| 'a') + 10
				when 'A' .. 'Z' then
				 	 Result := (c |-| 'A') + 10
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

	to_natural_8 (str: READABLE_STRING_GENERAL): NATURAL_8
			--
		do
			Result := substring_to_natural_8 (str, 1, str.count)
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
			i: INTEGER; c: CHARACTER; uc: CHARACTER_32
		do
			Result := True
			from i := start_index until not Result or i > end_index loop
				uc := str [i]
				if uc.is_character_8 then
					c := uc.to_character_8
					Result := is_valid_digit (c, i - start_index + 1)
				else
					Result := False
				end
				i := i + 1
			end
		end

feature -- Access

	bit_count: INTEGER
		-- number of bits to encode single binary, octal or hexadecimal digit
		deferred
		end

feature {NONE} -- Implementation

	character_array (
		str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER

	): TUPLE [area: SPECIAL [CHARACTER]; offset: INTEGER]
		local
			substring: STRING
		do
			create Result
			if str.is_string_8 and then attached {READABLE_STRING_8} str as str_8
				and then attached cursor_8 (str_8) as cursor
			then
				Result.offset := cursor.area_first_index
				Result.area := cursor.area
			elseif attached {EL_READABLE_ZSTRING} str as zstr then
				Result.area := zstr.area
			else
				substring := Buffer.copied_substring_general (str, start_index, end_index)
				Result := character_array (substring, 1, end_index - start_index + 1)
			end
		end

	is_leading_digit (c: CHARACTER; index: INTEGER): BOOLEAN
		deferred
		end

	is_valid_digit (c: CHARACTER; index: INTEGER): BOOLEAN
		deferred
		end

feature {NONE} -- Constants

	Buffer: EL_STRING_8_BUFFER
		once
			create Result
		end

end