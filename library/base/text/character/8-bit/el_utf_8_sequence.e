note
	description: "[
		UTF-8 sequence for single unicode ${CHARACTER_32}.
		Accessible via ${EL_SHARED_UTF_8_SEQUENCE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 13:27:29 GMT (Tuesday 20th August 2024)"
	revision: "19"

class
	EL_UTF_8_SEQUENCE

inherit
	EL_UTF_SEQUENCE
		rename
			set_area as set_sequence_area
		end

	STRING_HANDLER

create
	make

feature {NONE} -- Initialization

	make
		do
			make_filled_area (0, 4)
		end

feature -- Status query

	full: BOOLEAN
		local
			c: like area
		do
			c := area
			inspect count
				when 1 then
					Result := is_0xxxxxxx_sequence (c [0])
				when 2 then
					Result := is_110xxxxx_10xxxxxx_sequence (c [0], c [1])
				when 3 then
					Result := is_1110xxxx_10xxxxxx_10xxxxxx_sequence (c [0], c [1], c [2])
				when 4 then
					Result := is_11110xxx_10xxxxxx_10xxxxxx_10xxxxxx_sequence (c [0], c [1], c [2], c [3])
			else
				Result := True
			end
		ensure
			valid_sequence: Result implies is_valid
		end

	is_valid: BOOLEAN
		-- `True' if sequence is valid
		local
			c: like area
		do
			c := area
			inspect count
				when 1 then
					Result := is_0xxxxxxx_sequence (c [0])
				when 2 then
					Result := is_110xxxxx_10xxxxxx_sequence (c [0], c [1])
				when 3 then
					Result := is_1110xxxx_10xxxxxx_10xxxxxx_sequence (c [0], c [1], c [2])
				when 4 then
					Result := is_11110xxx_10xxxxxx_10xxxxxx_10xxxxxx_sequence (c [0], c [1], c [2], c [3])
			else
			end
		end

	same_sequence (a_area: SPECIAL [CHARACTER]; offset: INTEGER): BOOLEAN
		local
			l_count, i: INTEGER
		do
			l_count := count
			Result := True
			if attached area as l_area then
				from i := 0 until i = l_count or not Result loop
					Result := a_area [i + offset].natural_32_code = l_area [i]
					i := i + 1
				end
			end
		end

	strict_comparison (u_area, v_area: SPECIAL [CHARACTER]; u_index, v_index, n: INTEGER): INTEGER
		local
			i, j, i_delta, j_delta, k: INTEGER; i_code, j_code: NATURAL
		do
			from
				i := u_index; j := v_index; k := 1
			until
				k > n
			loop
				i_code := u_area [i].natural_32_code
				if i_code > 0x7F then
					fill (u_area, i)
					i_code := to_unicode; i_delta := count
				else
					i_delta := 1
				end
				j_code := u_area [j].natural_32_code
				if j_code > 0x7F then
					fill (v_area, j)
					j_code := to_unicode; j_delta := count
				else
					j_delta := 1
				end
				if i_code = j_code then
					i := i + i_delta; j := j + j_delta
				else
					Result := (i_code - j_code).to_integer_32
					k := n
				end
				k := k + 1
			end
		end

feature -- Element change

	fill (a_area: SPECIAL [CHARACTER]; offset: INTEGER)
		local
			l_count, i: INTEGER; c: EL_UTF_8_CONVERTER
		do
			wipe_out
			l_count := c.sequence_count (a_area [offset].natural_32_code)
			from until i = l_count loop
				area [i] := a_area [offset + i].natural_32_code
				i := i + 1
			end
			count := l_count
		end

	set (uc: CHARACTER_32)
		do
			set_area (uc.natural_32_code)
		end

	set_area (code: NATURAL)
		do
			if code <= 0x7F then
					-- 0xxxxxxx
				area [0] := code
				count := 1

			elseif code <= 0x7FF then
					-- 110xxxxx 10xxxxxx
				area [0] := (code |>> 6) | 0xC0
				area [1] := (code & 0x3F) | 0x80
				count := 2

			elseif code <= 0xFFFF then
					-- 1110xxxx 10xxxxxx 10xxxxxx
				area [0] := (code |>> 12) | 0xE0
				area [1] := ((code |>> 6) & 0x3F) | 0x80
				area [2] := (code & 0x3F) | 0x80
				count := 3
			else
					-- code <= 1FFFFF - there are no higher code points
					-- 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
				area [0] := (code |>> 18) | 0xF0
				area [1] := ((code |>> 12) & 0x3F) | 0x80
				area [2] := ((code |>> 6) & 0x3F) | 0x80
				area [3] := (code & 0x3F) | 0x80
				count := 4
			end
		end

feature -- Measurement

	character_index_of (uc: CHARACTER_32; utf_8_area: SPECIAL [CHARACTER]; start_index, end_index: INTEGER): INTEGER
		-- index of `uc' relative to `start_index - 1'
		-- 0 if `uc' does not occurr within item bounds
		require
			valid_start_index: utf_8_area.valid_index (start_index)
			valid_end_index: utf_8_area.valid_index (end_index)
		local
			i, i_delta, j: INTEGER; i_code, uc_code: NATURAL
		do
			uc_code := uc.natural_32_code
			from i := start_index; j := 1 until i > end_index or Result > 0 loop
				i_code := utf_8_area [i].natural_32_code
				if i_code > 0x7F then
					fill (utf_8_area, i)
					i_code := to_unicode; i_delta := count
				else
					i_delta := 1
				end
				if uc_code = i_code then
					Result := j
				end
				i := i + i_delta; j := j + 1
			end
		end

	substring_byte_count (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): INTEGER
		require
			start_index_valid: start_index >= 1
			end_index_valid: end_index <= str.count
			valid_bounds: start_index <= end_index + 1
		local
			i: INTEGER
		do
			from i := start_index until i > end_index loop
				Result := Result + byte_count (str [i].natural_32_code)
				i := i + 1
			end
		end

feature -- Conversion

	to_hexadecimal_escaped (escape_character: CHARACTER): STRING
		local
			i, l_count: INTEGER; l_area: like area
			code: NATURAL; buffer_area: like buffer.area
		do
			l_area := area; l_count := count
			Result := buffer
			Result.grow (l_count * 3)
			buffer_area := Result.area
			from i := 0 until i = l_count loop
				code := l_area [i]
				buffer_area [i * 3] := escape_character
				buffer_area [i * 3 + 1] := (code |>> 4).to_hex_character
				buffer_area [i * 3 + 2] := (code & 0xF).to_hex_character
				i := i + 1
			end
			Result.set_count (l_count * 3)
		end

	to_octal_escaped (escape_character: CHARACTER): STRING
		local
			i, l_count: INTEGER; l_area: like area
			code: NATURAL; buffer_area: like buffer.area
		do
			l_area := area; l_count := count
			Result := buffer
			Result.grow (l_count * 4)
			buffer_area := Result.area
			from i := 0 until i = l_count loop
				code := l_area [i]
				buffer_area [i * 4] := escape_character
				buffer_area [i * 4 + 1] := octal_character (code |>> 6)
				buffer_area [i * 4 + 2] := octal_character ((code |>> 3) & 0x7)
				buffer_area [i * 4 + 3] := octal_character (code & 0x7)
				i := i + 1
			end
			Result.set_count (l_count * 3)
		end

	to_unicode: NATURAL
		require
			valid_sequence: is_valid
		local
			c: like area
		do
			c := area
			inspect count
				when 1 then
					Result := c [0]
				when 2 then
					Result := ((c [0] & 0x1F) |<< 6) | (c [1] & 0x3F)
				when 3 then
					Result := (((c [0] & 0xF) |<< 12) | ((c [1] & 0x3F) |<< 6) | ( c [2] & 0x3F))
				when 4 then
					Result := ((((c [0] & 0x7) |<< 18) | ((c [1] & 0x3F) |<< 12) | ((c [2] & 0x3F) |<< 6)) | (c [3] & 0x3F))
			else
			end
		end

	to_utf_8: STRING
		do
			Result := buffer
			append_to_string (Result)
		end

feature -- Basic operations

	append_to_string (str: STRING)
		local
			i, l_count, old_count: INTEGER; l_area: like area
			buffer_area: like buffer.area
		do
			l_count := count
			if l_count = 1 then
				str.extend (area [0].to_character_8)
			else
				l_area := area; old_count := str.count
				str.grow (old_count + l_count)
				buffer_area := str.area
				from i := 0 until i = l_count loop
					buffer_area [old_count + i] := l_area [i].to_character_8
					i := i + 1
				end
				str.set_count (old_count + l_count)
			end
		end

	write (writeable: EL_WRITABLE)
		local
			i, l_count: INTEGER; l_area: like area
		do
			l_area := area; l_count := count
			from i := 0 until i = l_count loop
				writeable.write_encoded_character_8 (l_area [i].to_character_8)
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	is_0xxxxxxx_sequence (c1: NATURAL): BOOLEAN
		do
			Result := c1 <= 0x7F
		end

	is_110xxxxx_10xxxxxx_sequence (c1, c2: NATURAL): BOOLEAN
		do
			Result := c1 & 0xE0 = 0xC0 and then c2 & 0xC0 = 0x80
		end

	is_1110xxxx_10xxxxxx_10xxxxxx_sequence (c1, c2, c3: NATURAL): BOOLEAN
		do
			Result := c1 & 0xF0 = 0xE0 and then (c2 & 0xC0) = 0x80 and then (c2 & 0xC0) = 0x80
		end

	is_11110xxx_10xxxxxx_10xxxxxx_10xxxxxx_sequence (c1, c2, c3, c4: NATURAL): BOOLEAN
		do
			Result := c1 & 0xF8 = 0xF0 and then c2 & 0xC0 = 0x80 and then c3 & 0xC0 = 0x80 and then c4 & 0xC0 = 0x80
		end

	octal_character (n: NATURAL): CHARACTER_8
			-- Convert `n' to its corresponding character representation.
		do
			Result := (Zero_code + n).to_character_8
		end

feature {NONE} -- Constants

	Buffer: STRING = ""

	Zero_code: NATURAL = 48

end