note
	description: "Utf converter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-14 14:49:58 GMT (Tuesday 14th September 2021)"
	revision: "12"

expanded class
	EL_UTF_CONVERTER

inherit
	UTF_CONVERTER
		redefine
			is_valid_utf_16, utf_8_string_8_into_string_32
		end

	EL_MODULE_STRING_8

	STRING_HANDLER

feature -- Access

	frozen unicode_count (s: READABLE_STRING_8): INTEGER
		local
			i, end_index: INTEGER; area: SPECIAL [CHARACTER]
		do
			if attached string_8.cursor (s) as cursor then
				area := cursor.area
				end_index := cursor.area_last_index
				from i := cursor.area_first_index until i > end_index loop
					Result := Result + 1
					i := i + sequence_count (area [i].natural_32_code)
				end
			end
		end

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

feature -- Status query

	is_valid_utf_16 (s: SPECIAL [NATURAL_16]): BOOLEAN
			-- Is `s' a valid UTF-16 Unicode sequence?
		local
			i, n: INTEGER
			c1, c2: NATURAL_32
		do
			from
				i := 0
				n := s.count
				Result := True
			until
				i >= n or not Result
			loop
				c1 := s.item (i)
				if c1 = 0 then
						-- We hit our null terminating character, we can stop
					i := n + 1
				else
					if c1 < 0xD800 or c1 >= 0xE000 then
						-- Codepoint from Basic Multilingual Plane: one 16-bit code unit, this is valid Unicode.
						i := i + 1
					elseif c1 <= 0xDBFF then
						i := i + 1
						if i <= n then
							c2 := s.item (i)
							Result := 0xDC00 <= c2 and c2 <= 0xDFF
						else
								-- Surrogate pair is incomplete, clearly not a valid UTF-16 sequence.
							Result := False
						end
					else
							-- Invalid starting surrogate pair which should be between 0xD800 and 0xDBFF.
						Result := False
					end
				end
			end
		end

feature -- UTF-16 operations

	utf_16_be_0_pointer_into_string_32 (p: MANAGED_POINTER; a_result: STRING_32)
			-- Copy {STRING_32} object corresponding to UTF-16BE sequence `p' which is zero-terminated
			-- appended into `a_result'.
		require
			minimum_size: p.count >= 2
			valid_count: p.count \\ 2 = 0
		do
			utf_16_be_0_subpointer_into_string_32 (p, 0, p.count // 2 - 1, True, a_result)
		end

	utf_16_be_0_subpointer_into_string_32 (p: MANAGED_POINTER; start_pos, end_pos: INTEGER; a_stop_at_null: BOOLEAN; a_result: STRING_32)
			-- Copy {STRING_32} object corresponding to UTF-16BE sequence `p' between code units `start_pos' and
			-- `end_pos' or the first null character encountered if `a_stop_at_null' appended into `a_result'.
		require
			minimum_size: p.count >= 2
			start_position_big_enough: start_pos >= 0
			end_position_big_enough: start_pos <= end_pos + 1
			end_pos_small_enough: end_pos < p.count // 2
		local
			i, n: INTEGER
			c: NATURAL_32
		do
			from
					-- Allocate Result with the same number of bytes as copied from `p'.
				a_result.grow (a_result.count + end_pos - start_pos + 1)
				i := start_pos * 2
				n := end_pos * 2
			until
				i > n
			loop
				c := p.read_natural_16_be (i)
				if c = 0 and a_stop_at_null then
						-- We hit our null terminating character, we can stop
					i := n + 1
				else
					i := i + 2
					if c < 0xD800 or c >= 0xE000 then
							-- Codepoint from Basic Multilingual Plane: one 16-bit code unit.
						a_result.extend (c.to_character_32)
					else
							-- Supplementary Planes: surrogate pair with lead and trail surrogates.
						if i <= n then
							a_result.extend (((c.as_natural_32 |<< 10) + p.read_natural_16_be (i) - 0x35FDC00).to_character_32)
							i := i + 2
						end
					end
				end
			end
		end

feature -- UTF-8 operations

	utf_8_string_8_into_string_32 (s: READABLE_STRING_8; a_result: STRING_32)
		do
			utf_8_substring_8_into_string_32 (s, 1, s.count, a_result)
		end

	utf_8_substring_8_into_string_32 (s: READABLE_STRING_8; start_index, end_index: INTEGER; a_result: STRING_32)
			-- Copy STRING_32 corresponding to UTF-8 sequence `s.substring (start_index, end_index)' appended into `a_result'.
		local
			i, i_final, n, offset, byte_count: INTEGER; code: NATURAL_32
			area: SPECIAL [CHARACTER_8]
		do
			if attached string_8.cursor (s) as cursor then
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
				is_valid_utf_8_string_8 (str) implies
					utf_32_string_to_utf_8_string_8 (a_result.substring (old a_result.count + 1, a_result.count)).same_string (str)
		end

end