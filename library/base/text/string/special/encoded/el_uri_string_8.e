note
	description: "[
		A unicode string percent-encoded according to specification RFC 3986.
		See: https://en.wikipedia.org/wiki/Percent-encoding
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-26 13:22:04 GMT (Sunday 26th March 2023)"
	revision: "11"

class
	EL_URI_STRING_8

inherit
	EL_ENCODED_STRING_8
		redefine
			new_string
		end

	EL_URI_CHARACTER_QUERY_ROUTINES
		undefine
			copy, is_equal, out
		end

create
	make_encoded, make_empty, make

convert
	make_encoded ({STRING})

feature -- Access

	emptied: like Current
		do
			wipe_out
			Result := Current
		end

feature {NONE} -- Implementation

	is_reserved (c: CHARACTER_32): BOOLEAN
		do
			Result := is_generic_delimiter (c)
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