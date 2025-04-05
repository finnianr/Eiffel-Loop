note
	description: "UTF-8 string converter accessible from ${EL_MODULE_UTF_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-05 13:41:27 GMT (Saturday 5th April 2025)"
	revision: "4"

class
	EL_UTF_8_CONVERTER_IMP

inherit
	ANY

--	EL_SHARED_STRING_8_CURSOR

	EL_STRING_GENERAL_ROUTINES_I

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
			inspect string_storage_type (s)
				when 'X' then
					if attached {ZSTRING} s as zstr then
						Result := zstr.to_utf_8
					end
				when '4' then
					if attached {READABLE_STRING_32} s as str_32 then
						Result := c.string_32_to_utf_8_string_8 (str_32)
					end
			else
				Result := c.utf_32_string_to_utf_8_string_8 (s)
			end
		end

	string_32_to_string_8 (s: READABLE_STRING_32): STRING_8
			-- UTF-8 sequence corresponding to `s'.
		local
			c: UTF_CONVERTER
		do
			inspect string_storage_type (s)
				when 'X' then
					if attached {ZSTRING} s as zstr then
						Result := zstr.to_utf_8
					end
			else
				Result := c.string_32_to_utf_8_string_8 (s)
			end
		end

	to_string_32 (utf_8: READABLE_STRING_8): STRING_32
		do
			create Result.make (unicode_count (utf_8))
			string_8_into_string_general (utf_8, Result)
		end

feature -- Measurement

	frozen sequence_count (first_code: NATURAL): INTEGER
		-- utf-8 byte count indicated by first code in sequence

		-- selected		 : 296.0 times (100%)
		-- bit-shifting : 294.0 times (-0.7%)
		-- Using bit-shifting algorithm is slightly slower then selected alogorithm
		do
			if first_code <= 0x7F then -- 0xxxxxxx
				Result := 1
			elseif first_code <= 0xDF then -- 110xxxxx 10xxxxxx
				Result := 2
			elseif first_code <= 0xEF then -- 1110xxxx 10xxxxxx 10xxxxxx
				Result := 3
			elseif first_code <= 0xF7 then -- 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
				Result := 4
			else
				check
					valid_utf_8_character: False
				end
				Result := 1
			end
		end

	frozen unicode_count (str: READABLE_STRING_8): INTEGER
		do
			if attached super_readable_8 (str) as s then
				Result := array_unicode_count (s.area, s.index_lower, s.index_upper)
			end
		end

	frozen unicode_substring_count (str: READABLE_STRING_8; start_index, end_index: INTEGER): INTEGER
		require
			valid_start_index: str.valid_index (start_index)
			valid_end_index: end_index >= start_index - 1 and end_index <= str.count
		local
			first_index: INTEGER
		do
			if attached super_readable_8 (str) as s then
				first_index := s.index_lower + start_index - 1
				Result := array_unicode_count (s.area, first_index, first_index + end_index - start_index)
			end
		end

	frozen array_unicode_count (area: SPECIAL [CHARACTER]; first_index, last_index: INTEGER): INTEGER
		local
			i: INTEGER
		do
			from i := first_index until i > last_index loop
				Result := Result + 1
				i := i + sequence_count (area [i].natural_32_code)
			end
		end

	frozen memory_unicode_count (area: MANAGED_POINTER; first_index, last_index: INTEGER): INTEGER
		require
			valid_indices: first_index >= last_index + 1 and then last_index <= area.count
		local
			i: INTEGER
		do
			from i := first_index until i > last_index loop
				Result := Result + 1
				i := i + sequence_count (area.read_character (i).natural_32_code)
			end
		end

	frozen storage_count (iterable_list: ITERABLE [READABLE_STRING_GENERAL]; separator_count: INTEGER): INTEGER
		do
			across iterable_list as list loop
				if Result > 0 then
					Result := Result + separator_count
				end
				if attached super_readable_general (list.item) as str then
					Result := Result + str.utf_8_byte_count
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

	string_8_into_string_general (s: READABLE_STRING_8; a_result: STRING_GENERAL)
		do
			substring_8_into_string_general (s, 1, s.count, a_result)
		end

	substring_8_into_string_general (str: READABLE_STRING_8; start_index, end_index: INTEGER; a_result: STRING_GENERAL)
			-- Copy STRING_32 corresponding to UTF-8 sequence `s.substring (start_index, end_index)' appended into `a_result'.
		local
			i, i_final, n, offset, byte_count: INTEGER; code: NATURAL_32
			area: SPECIAL [CHARACTER_8]; area_32: SPECIAL [CHARACTER_32]
			s8: EL_STRING_8_ROUTINES; s32: EL_STRING_32_ROUTINES; sz: EL_ZSTRING_ROUTINES
		do
			if attached super_readable_8 (str) as s then
				area := s.area; offset := s.index_lower
			end
			n := end_index - start_index + 1
			if n > 0 then
				i_final := offset + start_index + n - 1
				create area_32.make_empty (n)
				from i := offset + start_index - 1 until i >= i_final loop
					code := area [i].natural_32_code
					byte_count := sequence_count (code)
					area_32.extend (unicode (area, code, i, byte_count).to_character_32)
					i := i + byte_count
				end
				inspect string_storage_type (a_result)
					when '1' then
						if attached {STRING_8} a_result as str_8 then
							s8.append_area_32 (str_8, area_32)
						end
					when '4' then
						if attached {STRING_32} a_result as str_32 then
							s32.append_area_32 (str_32, area_32)
						end
					when 'X' then
						if attached {ZSTRING} a_result as zstr then
							sz.append_area_32 (zstr, area_32)
						end
				else
					i_final := area_32.count
					from i := 0 until i = i_final loop
						a_result.append_code (area_32 [i].natural_32_code)
						i := i + 1
					end
				end
			end
		ensure
			roundtrip: attached str.substring (start_index, end_index) as s and then is_valid_string_8 (s)
				implies
					utf_32_string_to_string_8 (a_result.substring (old a_result.count + 1, a_result.count)).same_string (s)
		end

end