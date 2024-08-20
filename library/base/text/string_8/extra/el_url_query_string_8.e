note
	description: "URL query string"
	notes: "[
		* SPACE is encoded as '+' or '%20'
		* Letters (A-Z and a-z), numbers (0-9) and the characters '~', '-', '.' and '_' are left as-is + is encoded by %2B
		* All other characters are encoded as %HH hex representation with any non-ASCII characters
		first encoded as UTF-8 (or other specified encoding)

		The octet corresponding to the tilde ("~") is permitted in query strings by RFC3986 but required to be
		percent-encoded in HTML forms to "%7E".

		The encoding of SPACE as '+' and the selection of "as-is" characters distinguishes this encoding
		from [https://tools.ietf.org/html/rfc3986 RFC 3986].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 13:05:57 GMT (Tuesday 20th August 2024)"
	revision: "7"

class
	EL_URL_QUERY_STRING_8

inherit
	EL_URI_QUERY_STRING_8
		redefine
			adjusted_character, append_unencoded, is_unreserved, is_reserved
		end

create
	make_encoded, make_empty, make

feature {NONE} -- Implementation

	adjusted_character (c: CHARACTER): CHARACTER
		do
			if c = '+' then
				Result := ' '
			else
				Result := c
			end
		end

	append_unencoded (c: CHARACTER_8)
		do
			if c = ' ' then
				append_character ('+')
			else
				append_character (c)
			end
		end

	is_unreserved (c: CHARACTER_32): BOOLEAN
		do
			if c = ' ' then
				Result := True
			else
				Result := Precursor (c)
			end
		end

	is_reserved (c: CHARACTER_32): BOOLEAN
		do
			inspect c
				when '+' then
					Result := False
			else
				Result := is_allowed_in_query (c)
			end
		end
end