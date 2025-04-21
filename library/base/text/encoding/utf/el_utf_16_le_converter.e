note
	description: "	Little Endian UTF-16 string converter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-20 11:38:54 GMT (Sunday 20th April 2025)"
	revision: "8"

expanded class
	EL_UTF_16_LE_CONVERTER

inherit
	EL_EXPANDED_ROUTINES

	EL_SHARED_CHARACTER_AREA_ACCESS

feature -- Conversion

	merged_points (code_1, code_2: NATURAL): NATURAL
		-- `True' if UTF-16 `code' matches a unicode value
		-- i.e. is a codepoint from basic multilingual plane: one 16-bit code unit.
		do
			Result := (code_1 |<< 10) + code_2 - 0x35FDC00
		end

	frozen unicode (area: SPECIAL [CHARACTER_8]; code_1: NATURAL_32; offset, byte_count: INTEGER): NATURAL
		-- return unicode encoded as `byte_count' bytes from `offset' in `area'
		local
			code_2: NATURAL
		do
			inspect byte_count
				when 2 then
					Result := code_1
				when 4 then
					code_2 := area [offset + 2].natural_32_code | (area [offset + 3].natural_32_code |<< 8)
					Result := (code_1 |<< 10) + code_2 - 0x35FDC00
			else
			end
		end

	string_32_to_string_8 (s: READABLE_STRING_32): STRING_8
			-- UTF-8 sequence corresponding to `s'.
		local
			c: UTF_CONVERTER
		do
			Result := c.utf_32_string_to_utf_16le_string_8 (s)
		end

	utf_32_string_to_string_8 (s: READABLE_STRING_GENERAL): STRING_8
			-- UTF-16 LE sequence corresponding to `s' interpreted as a UTF-32 sequence.
		local
			c: UTF_CONVERTER
		do
			Result := c.utf_32_string_to_utf_16le_string_8 (s)
		end

feature -- Measurement

	frozen sequence_count (code: NATURAL): INTEGER
		-- utf-16 byte count indicated by first NATURAL_16 code in sequence
		do
			if is_single_point (code) then
				Result := 2
			else
				Result := 4
			end
		end

	frozen unicode_count (s: READABLE_STRING_8): INTEGER
		local
			i, i_lower, i_upper: INTEGER
		do
			if attached Character_area_8.get (s, $i_lower, $i_upper) as area then
				from i := i_lower until i > i_upper loop
					Result := Result + 1
					i := i + sequence_count (area [i].natural_32_code | (area [i + 1].natural_32_code |<< 8))
				end
			end
		end

feature -- Status report

	is_valid_string_8 (s: READABLE_STRING_8): BOOLEAN
			-- Is `s' a valid UTF-16 little endian Unicode sequence?
		local
			c: UTF_CONVERTER
		do
			Result := c.is_valid_utf_16le_string_8 (s)
		end

	is_single_point (code: NATURAL): BOOLEAN
		-- `True' if UTF-16 `code' matches a unicode value
		-- i.e. is a codepoint from basic multilingual plane: one 16-bit code unit.
		do
			Result := code < 0xD800 or code >= 0xE000
		end

feature -- Basic operations

	string_8_into_string_32 (s: READABLE_STRING_8; a_result: STRING_32)
		do
			substring_8_into_string_32 (s, 1, s.count, a_result)
		end

	substring_8_into_string_32 (s: READABLE_STRING_8; start_index, end_index: INTEGER; a_result: STRING_32)
			-- Copy STRING_32 corresponding to UTF-16 LE sequence `s.substring (start_index, end_index)'
			-- appended into `a_result'.
		local
			i, i_final, n, offset, byte_count: INTEGER; code: NATURAL_32
			area: SPECIAL [CHARACTER_8]
		do
			area := Character_area_8.get_lower (s, $offset)
			n := end_index - start_index + 1
			i_final := offset + start_index + n - 1
			a_result.grow (a_result.count + n)
			from i := offset + start_index - 1 until i >= i_final loop
				code := area [i].natural_32_code | (area [i + 1].natural_32_code |<< 8)
				byte_count := sequence_count (code)
				a_result.append_code (unicode (area, code, i, byte_count))
				i := i + byte_count
			end
		ensure
			roundtrip: attached s.substring (start_index, end_index) as str and then
				is_valid_string_8 (str) implies
					utf_32_string_to_string_8 (a_result.substring (old a_result.count + 1, a_result.count)).same_string (str)
		end
end