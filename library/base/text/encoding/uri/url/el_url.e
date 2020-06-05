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
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-02 8:43:07 GMT (Tuesday 2nd June 2020)"
	revision: "2"

class
	EL_URL

inherit
	EL_URI
		rename
			Uri_query as Url_query
		redefine
			Url_query
		end

create
	make_empty, make, make_from_general

convert
	make ({STRING_8})

feature -- Access

	query_table: EL_URI_QUERY_ZSTRING_HASH_TABLE
		do
			create Result.make_url (query)
		end

feature -- Element change

	set_query_from_table (a_table: HASH_TABLE [READABLE_STRING_GENERAL, READABLE_STRING_GENERAL])
		local
			table: EL_URI_QUERY_ZSTRING_HASH_TABLE
		do
			create table.make_equal (a_table.count)
			across a_table as t loop
				table.set_string_general (t.key, t.item)
			end
			set_encoded_query (table.url_query)
		end

feature {NONE} -- Constants

	Url_query: EL_URL_QUERY_STRING_8
		once
			create Result.make_empty
		end

end
