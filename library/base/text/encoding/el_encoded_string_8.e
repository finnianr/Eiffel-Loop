note
	description: "[
		A string with a mix of literal characters and characters represented as an escape sequence
		starting with character `escape_character'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-01 10:38:32 GMT (Saturday 1st February 2020)"
	revision: "7"

deferred class
	EL_ENCODED_STRING_8

inherit
	STRING
		rename
			append as append_raw_8,
			append_substring_general as append_raw_substring_general,
			make_from_string as make_encoded,
			set as set_encoded
		export
			{NONE} all
			{ANY} append_character, is_empty, wipe_out, share, set_encoded, count, area,
			capacity, same_string, to_c, to_string_8,
			Is_string_8
		end

	EL_MODULE_UTF

	EL_MODULE_HEXADECIMAL

	EL_SHARED_ONCE_STRING_32

feature -- Conversion

	decoded: ZSTRING
		do
			create Result.make_from_utf_8 (to_utf_8)
		end

	decoded_8: STRING_8
		do
			Result := empty_once_string_32
			UTF.utf_8_string_8_into_string_32 (to_utf_8, Result)
			Result := Result.to_string_8
		end

	decoded_32: STRING_32
		do
			Result := empty_once_string_32
			UTF.utf_8_string_8_into_string_32 (to_utf_8, Result)
			Result := Result.twin
		end

	to_utf_8: STRING
		-- unescaped utf-8
		local
			l_area: like area; i, step: INTEGER; c: CHARACTER
		do
			create Result.make (count - occurrences (escape_character) * sequence_count)
			l_area := area
			from i := 0 until i = count loop
				c := l_area [i]
				if c = escape_character and then is_sequence (l_area, i + 1) then
					Result.append_code (sequence_code (l_area, i + 1))
					step := sequence_count + 1
				else
					Result.append_character (adjusted_character (c))
					step := 1
				end
				i := i + step
			end
		end

feature -- Element change

	append_general (s: READABLE_STRING_GENERAL)
		do
			append_substring_general (s, 1, s.count)
		end

	append_substring_general (s: READABLE_STRING_GENERAL; start_index, end_index: INTEGER)
		require
			start_index_valid: start_index >= 1
			end_index_valid: end_index <= s.count
			valid_bounds: start_index <= end_index + 1
		local
			uc: CHARACTER_32; i, utf_count, s_count: INTEGER
			utf_8: like Utf_8_sequence
		do
			utf_8 := Utf_8_sequence
			s_count := end_index - start_index + 1
			utf_count := utf_8.byte_count (s, start_index, end_index)
			grow (count + utf_count + (utf_count - s_count) // 2)
			from i := start_index until i > end_index loop
				uc := s [i]
				if is_unescaped_basic (uc) or else is_unescaped_extra (uc) then
					append_character (uc.to_character_8)
				else
					append_encoded	(utf_8, uc)
				end
				i := i + 1
			end
		ensure
			reversible: substring_utf_8 (s, start_index, end_index) ~ substring (old count + 1, count).to_utf_8
		end

	append_unencoded_general (s: READABLE_STRING_GENERAL)
		-- append `s' without any encoding
		do
			append_unencoded_substring_general (s, 1, s.count)
		end

	append_unencoded_substring_general (s: READABLE_STRING_GENERAL; start_index, end_index: INTEGER)
		-- append `s' without any encoding from `start_index' to `end_index'
		require
			start_index_valid: start_index >= 1
			end_index_valid: end_index <= s.count
			valid_bounds: start_index <= end_index + 1
		local
			uc: CHARACTER_32; i, j: INTEGER
			l_area: like area
		do
			grow (count + end_index - start_index + 1)
			l_area := area
			from i := start_index until i > end_index loop
				uc := s [i]; j := count + i - start_index
				if uc.is_character_8 then
					l_area [j] := uc.to_character_8
				else
					l_area [j] := Unencoded_character
				end
				i := i + 1
			end
			set_count (count + end_index - start_index + 1)
			internal_hash_code := 0
		ensure
			appended_is_unencoded: s.same_characters (Current, start_index, end_index, old count + 1)
		end

	set_from_string (str: ZSTRING)
		do
			wipe_out
			append_general (str)
		end

feature {NONE} -- Implementation

	adjusted_character (c: CHARACTER): CHARACTER
		do
			Result := c
		end

	append_encoded (utf_8: like Utf_8_sequence; uc: CHARACTER_32)
		do
			utf_8.set (uc)
			append_string (utf_8.to_hexadecimal_escaped (Escape_character))
		end

	is_sequence (a_area: like area; offset: INTEGER): BOOLEAN
		local
			i: INTEGER
		do
			if offset + sequence_count <= count then
				Result := True
				from i := 0 until not Result or i = sequence_count loop
					Result := is_sequence_digit (a_area [offset + i])
					i := i + 1
				end
			end
		end

	is_sequence_digit (c: CHARACTER): BOOLEAN
		do
			Result := c.is_hexa_digit
		end

	is_unescaped_basic (c: CHARACTER_32): BOOLEAN
		do
			inspect c
				when '0' .. '9', 'A' .. 'Z', 'a' .. 'z' then
					Result := True

			else end
		end

	sequence_code (a_area: like area; offset: INTEGER): NATURAL
		local
			hi_c, low_c: NATURAL
		do
			hi_c := a_area.item (offset).natural_32_code
			low_c := a_area.item (offset + 1).natural_32_code
			Result := (Hexadecimal.to_decimal (hi_c) |<< 4) | Hexadecimal.to_decimal (low_c)
		end

	substring_utf_8 (s: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): STRING
		do
			Result := UTF.utf_32_string_to_utf_8_string_8 (s.substring (start_index, end_index).to_string_32)
		end

feature {NONE} -- Deferred implementation

	escape_character: CHARACTER
		-- escape sequence start character
		deferred
		end

	is_unescaped_extra (c: CHARACTER_32): BOOLEAN
		deferred
		end

	sequence_count: INTEGER
		-- count of escape sequence digits
		deferred
		end

feature {NONE} -- Constants

	Utf_8_sequence: EL_UTF_8_SEQUENCE
		once
			create Result.make
		end

	Unencoded_character: CHARACTER = '%/026/'
		-- The substitute character SUB
		-- A substitute character (SUB) is a control character that is used in the place of a character that is
		-- recognized to be invalid or in error or that cannot be represented on a given device.
		-- See https://en.wikipedia.org/wiki/Substitute_character
end
