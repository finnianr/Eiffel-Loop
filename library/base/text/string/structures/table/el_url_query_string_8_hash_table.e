note
	description: "Hash table of URL query string name-value pairs"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-24 11:09:08 GMT (Sunday 24th May 2020)"
	revision: "14"

class
	EL_URL_QUERY_STRING_8_HASH_TABLE

inherit
	EL_URI_QUERY_HASH_TABLE [STRING_8]

create
	make_equal, make, make_default

feature {NONE} -- Implementation

	decoded_string (url: EL_URI_QUERY_STRING_8): STRING_8
		do
			Result := url.decoded_8
		end
end
