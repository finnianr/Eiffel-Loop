note
	description: "[
		A unicode string percent-encoded according to specification RFC 3986.
		See: https://en.wikipedia.org/wiki/Percent-encoding
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-24 11:35:41 GMT (Sunday 24th May 2020)"
	revision: "4"

class
	EL_URI_STRING_8

inherit
	EL_ENCODED_STRING_8
		redefine
			new_string, adjusted_character, append_unencoded, is_unreserved
		end

	EL_SHARED_URI_RESERVED_CHARS

create
	make_encoded, make_empty, make

convert
	make_encoded ({STRING})

feature -- Element change

	set_reserved_characters (character_set: STRING)
		do
			reserved_character_set := character_set
		end

	set_plus_sign_equals_space (a_plus_sign_equals_space: BOOLEAN)
		do
			plus_sign_equals_space := a_plus_sign_equals_space
		end

feature -- Status change

	disable_escape_space_as_plus
		do
			plus_sign_equals_space := False
		end

	escape_space_as_plus
		do
			plus_sign_equals_space := True
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

	append_unencoded (c: CHARACTER_8)
		do
			if c = ' ' and then plus_sign_equals_space then
				append_character ('+')
			else
				append_character (c)
			end
		end

	is_unreserved (c: CHARACTER_32): BOOLEAN
		do
			if c = ' ' and then plus_sign_equals_space then
				Result := True
			else
				Result := Precursor (c)
			end
		end

	new_string (n: INTEGER): like Current
			-- New instance of current with space for at least `n' characters.
		do
			create Result.make (n)
		end

	set_reserved_character_set
		do
			reserved_character_set := Uri_reserved_chars.generic_delimiters
		end

feature {NONE} -- Constants

	Escape_character: CHARACTER = '%%'

	Sequence_count: INTEGER = 2
end
