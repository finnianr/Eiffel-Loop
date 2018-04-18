note
	description: "[
		A string with a mix of literal characters and characters represented as an escape sequence
		starting with character `escape_character'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-09 17:42:15 GMT (Monday 9th April 2018)"
	revision: "2"

deferred class
	EL_ENCODED_STRING_8

inherit
	STRING
		rename
			append as append_8,
			make_from_string as make_encoded,
			set as set_encoded
		export
			{NONE} all
			{ANY} Is_string_8, wipe_out, share, set_encoded, count, area, is_empty, capacity, same_string

		end

	EL_MODULE_UTF
		undefine
			is_equal, copy, out
		end

	EL_MODULE_HEXADECIMAL
		undefine
			is_equal, copy, out
		end

feature -- Conversion

	to_string: ZSTRING
		do
			create Result.make_from_utf_8 (to_utf_8)
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
		local
			i, s_count: INTEGER; uc: CHARACTER_32; utf_count: INTEGER
			utf_8: like Utf_8_sequence
		do
			utf_8 := Utf_8_sequence
			s_count := s.count
			utf_count := utf_8_bytes_count (utf_8, s)
			grow (count + utf_count + (utf_count - s_count) // 2)
			from i := 1 until i > s_count loop
				uc := s [i]
				if is_unescaped_basic (uc) then
					append_code (uc.natural_32_code)
				elseif is_unescaped_extra (uc) then
					append_code (uc.natural_32_code)
				else
					append_encoded	(utf_8, uc)
				end
				i := i + 1
			end
		ensure
			reversible: UTF.utf_32_string_to_utf_8_string_8 (s.to_string_32) ~ substring (old count + 1, count).to_utf_8
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
			utf_8.append_hexadecimal_escaped_to (Current, Escape_character)
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

	utf_8_bytes_count (utf_8: like Utf_8_sequence; s: READABLE_STRING_GENERAL): INTEGER
		local
			i, s_count: INTEGER
		do
			s_count := s.count
			from i := 1 until i > s_count loop
				utf_8.set (s [i])
				Result := Result + utf_8.count
				i := i + 1
			end
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

end
