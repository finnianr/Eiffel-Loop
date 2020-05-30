note
	description: "[
		A unicode string percent-encoded according to specification RFC 3986.
		See: https://en.wikipedia.org/wiki/Percent-encoding
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-29 17:38:44 GMT (Friday 29th May 2020)"
	revision: "6"

class
	EL_URI_STRING_8

inherit
	EL_ENCODED_STRING_8
		redefine
			new_string
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

feature {NONE} -- Implementation

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
