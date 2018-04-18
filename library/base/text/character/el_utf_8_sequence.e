note
	description: "UTF-8 sequence for single unicode character `uc'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-09 10:58:59 GMT (Monday 9th April 2018)"
	revision: "2"

class
	EL_UTF_8_SEQUENCE

inherit
	EL_UTF_SEQUENCE

create
	make

feature {NONE} -- Initialization

	make
		do
			make_filled_area (0, 4)
		end

feature -- Element change

	set (uc: CHARACTER_32)
		local
			code: NATURAL; l_area: like area
		do
			l_area := area
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

feature -- Basic operations

	append_hexadecimal_escaped_to (str: STRING; escape_character: CHARACTER)
		local
			i, l_count: INTEGER; l_area: like area
			code: NATURAL
		do
			l_area := area; l_count := count
			from i := 0 until i = l_count loop
				code := l_area [i]
				str.append_character (escape_character)
				str.append_character ((code |>> 4).to_hex_character)
				str.append_character ((code & 0xF).to_hex_character)
				i := i + 1
			end
		end

	append_octal_escaped_to (str: STRING; escape_character: CHARACTER)
		local
			i, l_count: INTEGER; l_area: like area
			code: NATURAL
		do
			l_area := area; l_count := count
			from i := 0 until i = l_count loop
				code := l_area [i]
				str.append_character (escape_character)
				str.append_character (octal_character (code |>> 6))
				str.append_character (octal_character ((code |>> 3) & 0x7 ))
				str.append_character (octal_character (code & 0x7))
				i := i + 1
			end
		end

	append_to (str: STRING)
		local
			i, l_count: INTEGER; l_area: like area
		do
			l_area := area; l_count := count
			from i := 0 until i = l_count loop
				str.append_code (l_area.item (i))
				i := i + 1
			end
		end

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

	octal_character (n: NATURAL): CHARACTER_8
			-- Convert `n' to its corresponding character representation.
		do
			Result := (Zero_code + n).to_character_8
		end

feature {NONE} -- Constants

	Zero_code: NATURAL = 48

end
