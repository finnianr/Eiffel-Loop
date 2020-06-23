note
	description: "UTF-8 sequence for single unicode character `uc'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-22 15:17:33 GMT (Monday 22nd June 2020)"
	revision: "7"

class
	EL_UTF_8_SEQUENCE

inherit
	EL_UTF_SEQUENCE

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

feature -- Element change

	set (uc: CHARACTER_32)
		local
			code: NATURAL
		do
			code := uc.natural_32_code
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

	substring_byte_count (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): INTEGER
		require
			start_index_valid: start_index >= 1
			end_index_valid: end_index <= str.count
			valid_bounds: start_index <= end_index + 1
		local
			i: INTEGER
		do
			from i := start_index until i > end_index loop
				Result := Result + byte_count (str.item (i).natural_32_code)
				i := i + 1
			end
		end

	byte_count (code: NATURAL): INTEGER
		do
			if code <= 0x7F then
					-- 0xxxxxxx
				Result := 1

			elseif code <= 0x7FF then
					-- 110xxxxx 10xxxxxx
				Result := 2

			elseif code <= 0xFFFF then
					-- 1110xxxx 10xxxxxx 10xxxxxx
				Result := 3
			else
					-- code <= 1FFFFF - there are no higher code points
					-- 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
				Result := 4
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
		local
			i, l_count: INTEGER; l_area: like area
			buffer_area: like buffer.area
		do
			l_area := area; l_count := count
			Result := buffer
			Result.grow (l_count)
			buffer_area := Result.area
			from i := 0 until i = l_count loop
				buffer_area [i] := l_area.item (i).to_character_8
				i := i + 1
			end
			Result.set_count (l_count)
		end

feature -- Basic operations

	write (writeable: EL_WRITEABLE)
		local
			i, l_count: INTEGER; l_area: like area
		do
			l_area := area; l_count := count
			from i := 0 until i = l_count loop
				writeable.write_raw_character_8 (l_area.item (i).to_character_8)
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
