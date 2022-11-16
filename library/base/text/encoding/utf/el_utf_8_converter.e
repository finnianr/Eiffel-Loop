note
	description: "UTF-8 string converter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

expanded class
	EL_UTF_8_CONVERTER

inherit
	EL_EXPANDED_ROUTINES

	EL_SHARED_STRING_8_CURSOR

feature -- Conversion

	frozen unicode (area: SPECIAL [CHARACTER_8]; leading_byte: NATURAL_32; offset, byte_count: INTEGER): NATURAL
		-- return unicode encoded as `byte_count' bytes from `offset' in `area'
		local
			i: INTEGER
		do
			inspect byte_count
				when 1 then -- 0xxxxxxx
					Result := leading_byte
				when 2 then -- 110xxxxx 10xxxxxx
					Result := leading_byte & 0x1F
				when 3 then -- 1110xxxx 10xxxxxx 10xxxxxx
					Result := leading_byte & 0xF
				when 4 then -- 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
					Result := leading_byte & 0x7
			else
			end
			from i := 1 until i = byte_count loop
				Result := (Result |<< 6) | (area [offset + i].natural_32_code & 0x3F)
				i := i + 1
			end
		end

	utf_32_string_to_string_8 (s: READABLE_STRING_GENERAL): STRING_8
			-- UTF-8 sequence corresponding to `s' interpreted as a UTF-32 sequence.
		local
			c: UTF_CONVERTER
		do
			Result := c.utf_32_string_to_utf_8_string_8 (s)
		end

	string_32_to_string_8 (s: READABLE_STRING_32): STRING_8
			-- UTF-8 sequence corresponding to `s'.
		local
			c: UTF_CONVERTER
		do
			Result := c.string_32_to_utf_8_string_8 (s)
		end

feature -- Measurement

	frozen sequence_count (first_code: NATURAL): INTEGER
		-- utf-8 byte count indicated by first code in sequence
		do
			if first_code <= 0x7F then -- 0xxxxxxx
				Result := 1
			elseif first_code <= 0xDF then -- 110xxxxx 10xxxxxx
				Result := 2
			elseif first_code <= 0xEF then -- 1110xxxx 10xxxxxx 10xxxxxx
				Result := 3
			elseif first_code <= 0xF7 then -- 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
				Result := 4
			end
		end

	frozen unicode_count (s: READABLE_STRING_8): INTEGER
		local
			i, end_index: INTEGER; area: SPECIAL [CHARACTER]
		do
			if attached cursor_8 (s) as c then
				area := c.area; end_index := c.area_last_index
				from i := c.area_first_index until i > end_index loop
					Result := Result + 1
					i := i + sequence_count (area [i].natural_32_code)
				end
			end
		end

feature -- Status report

	is_valid_string_8 (s: READABLE_STRING_8): BOOLEAN
			-- Is `s' a valid UTF-8 Unicode sequence?
		local
			c: UTF_CONVERTER
		do
			Result := c.is_valid_utf_8_string_8 (s)
		end

feature -- Basic operations

	string_8_into_string_32 (s: READABLE_STRING_8; a_result: STRING_32)
		do
			substring_8_into_string_32 (s, 1, s.count, a_result)
		end

	substring_8_into_string_32 (s: READABLE_STRING_8; start_index, end_index: INTEGER; a_result: STRING_32)
			-- Copy STRING_32 corresponding to UTF-8 sequence `s.substring (start_index, end_index)' appended into `a_result'.
		local
			i, i_final, n, offset, byte_count: INTEGER; code: NATURAL_32
			area: SPECIAL [CHARACTER_8]
		do
			if attached cursor_8 (s) as cursor then
				area := cursor.area; offset := cursor.area_first_index
			end
			n := end_index - start_index + 1
			i_final := offset + start_index + n - 1
			a_result.grow (a_result.count + n)
			from i := offset + start_index - 1 until i >= i_final loop
				code := area [i].natural_32_code
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