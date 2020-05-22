note
	description: "[
		A unicode string percent-encoded according to specification RFC 3986.
		See: https://en.wikipedia.org/wiki/Percent-encoding
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-22 15:22:52 GMT (Friday 22nd May 2020)"
	revision: "3"

class
	EL_URI_STRING_8

inherit
	EL_ENCODED_STRING_8
		redefine
			new_string, adjusted_character, append_character
		end

create
	make_encoded, make_empty, make

convert
	make_encoded ({STRING})

feature -- Element change

	append_character (c: CHARACTER_8)
		do
			if c = ' ' and then plus_sign_equals_space then
				Precursor ('+')
			else
				Precursor (c)
			end
		end

feature -- Status change

	escape_space_as_plus
		do
			plus_sign_equals_space := True
		end

	escape_space_as_space
		do
			plus_sign_equals_space := False
		end

feature -- Status query

	plus_sign_equals_space: BOOLEAN

feature {NONE} -- Implementation

	adjusted_character (c: CHARACTER): CHARACTER
		do
			if c = '+' and then plus_sign_equals_space then
				Result := ' '
			else
				Result := c
			end
		end

	is_unescaped_extra (c: CHARACTER_32): BOOLEAN
		do
			inspect c
				when '-', '_', '.', '~' then
					Result := True

			else end
		end

	new_string (n: INTEGER): like Current
			-- New instance of current with space for at least `n' characters.
		do
			create Result.make (n)
		end

feature {NONE} -- Constants

	Escape_character: CHARACTER = '%%'

	Sequence_count: INTEGER = 2
end
