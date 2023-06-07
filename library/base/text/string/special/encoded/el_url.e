note
	description: "Uniform Resource Locator"
	notes: "[
		**For the Query part**

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
	date: "2023-06-07 13:39:07 GMT (Wednesday 7th June 2023)"
	revision: "6"

class
	EL_URL

inherit
	EL_URI
		rename
			Uri_query as Url_query
		redefine
			is_url, Url_query
		end

create
	make_empty, make, make_from_general

convert
	make ({STRING_8})

feature -- Status query

	Is_url: BOOLEAN = True

feature {NONE} -- Constants

	Url_query: EL_URL_QUERY_STRING_8
		once
			create Result.make_empty
		end

end