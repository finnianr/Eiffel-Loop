note
	description: "[
		Cookie value string with decimal encoded UTF-8 sequences
		Eg. `"Köln-Altstadt-Süd"' becomes `"K\303\266ln-Altstadt-S\303\274d"'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-09 16:25:34 GMT (Monday 9th April 2018)"
	revision: "2"

class
	EL_COOKIE_STRING_8

inherit
	EL_ENCODED_STRING_8
		rename
			is_sequence_digit as is_octal_digit
		redefine
			append_encoded, is_octal_digit, is_unescaped_basic, new_string, sequence_code
		end

	EL_MODULE_OCTAL
		undefine
			is_equal, copy, out
		end

create
	make_encoded, make_empty, make

convert
	make_encoded ({STRING})

feature {NONE} -- Implementation

	append_encoded (utf_8: like Utf_8_sequence; uc: CHARACTER_32)
		do
			utf_8.set (uc)
			utf_8.append_octal_escaped_to (Current, Escape_character)
		end

	is_unescaped_basic (c: CHARACTER_32): BOOLEAN
		-- The value of a cookie may consist of any printable ASCII character
		--  (! through ~, Unicode \u0021 through \u007E) excluding , and ; and whitespace characters.
		do
			inspect c
				when ',', ';', ' ' then
			else
				inspect c
					when '!' .. '~' then
						Result := True
				else end
			end
		end

	is_unescaped_extra (c: CHARACTER_32): BOOLEAN
		do
		end

	is_octal_digit (c: CHARACTER): BOOLEAN
		do
			inspect c
				when '0' .. '7' then
					Result := True
			else end
		end

	new_string (n: INTEGER): like Current
			-- New instance of current with space for at least `n' characters.
		do
			create Result.make (n)
		end

	sequence_code (a_area: like area; offset: INTEGER): NATURAL
		do
			Result := Octal.substring_to_natural_32 (Current, offset + 1, offset + sequence_count)
		end

feature {NONE} -- Constants

	Escape_character: CHARACTER = '\'

	Sequence_count: INTEGER = 3

end
