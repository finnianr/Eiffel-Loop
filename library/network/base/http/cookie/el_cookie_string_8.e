note
	description: "[
		Cookie value string with hexadecimal encoded UTF-8 sequences
		Eg. `"Köln-Altstadt-Süd"' becomes `"K%C3%B6ln-Altstadt-S%C3%BCd"'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-11 14:21:09 GMT (Tuesday 11th February 2025)"
	revision: "11"

class
	EL_COOKIE_STRING_8

inherit
	EL_ENCODED_STRING_8
		redefine
			is_unreserved, new_string
		end

create
	make_encoded, make_empty, make, make_from_general

convert
	make_encoded ({STRING})

feature {NONE} -- Implementation

	is_unreserved (c: CHARACTER_32): BOOLEAN
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

	is_reserved (c: CHARACTER_32): BOOLEAN
		do
		end

	new_string (n: INTEGER): like Current
			-- New instance of current with space for at least `n' characters.
		do
			create Result.make (n)
		end

feature {NONE} -- Constants

	Escape_character: CHARACTER
		once
			Result := '%%'
		end

	Sequence_count: INTEGER
		once
			Result := 2
		end

end