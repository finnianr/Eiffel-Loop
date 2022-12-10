note
	description: "[
		Cookie value string with octal encoded UTF-8 sequences
		Eg. `"Köln-Altstadt-Süd"' becomes `"K\303\266ln-Altstadt-S\303\274d"'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-10 17:36:48 GMT (Saturday 10th December 2022)"
	revision: "1"

class
	EL_OCTAL_COOKIE_STRING_8

inherit
	EL_COOKIE_STRING_8
		redefine
			is_sequence_digit, sequence_code, Escape_character, Sequence_count
		end

create
	make_encoded, make_empty, make

convert
	make_encoded ({STRING})

feature {NONE} -- Implementation

	is_sequence_digit (c: CHARACTER): BOOLEAN
		do
			inspect c
				when '0' .. '7' then
					 Result := True
			else
			end
		end

	sequence_code (a_area: like area; offset: INTEGER): NATURAL
		local
			l_code: INTEGER_64; oct: EL_OCTAL_CONVERTER
			i: INTEGER
		do
			from i := 0 until i = 3 loop
				l_code := (l_code |<< 3) | oct.to_decimal (a_area [offset + i])
				i := i + 1
			end
			Result := l_code.to_natural_32
		end

feature {NONE} -- Constants

	Escape_character: CHARACTER = '\'

	Sequence_count: INTEGER = 3
end