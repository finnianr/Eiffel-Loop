note
	description: "[
		A unicode string percent-encoded according to specification RFC 3986.
		See: https://en.wikipedia.org/wiki/Percent-encoding
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-11 14:20:54 GMT (Tuesday 11th February 2025)"
	revision: "14"

class
	EL_URI_STRING_8

inherit
	EL_ENCODED_STRING_8
		export
			{STRING_HANDLER} append_raw_8
		redefine
			new_string
		end

	EL_URI_CHARACTER_QUERY_ROUTINES
		undefine
			copy, is_equal, out
		end

create
	make_encoded, make_empty, make, make_from_general

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