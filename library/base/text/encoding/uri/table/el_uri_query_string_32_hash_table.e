note
	description: "Hash table of URL query string name-value pairs"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-28 12:36:55 GMT (Thursday 28th May 2020)"
	revision: "15"

class
	EL_URI_QUERY_STRING_32_HASH_TABLE

inherit
	EL_URI_QUERY_HASH_TABLE [STRING_32]

create
	make_equal, make_url, make_uri, make_default

feature {NONE} -- Implementation

	decoded_string (url: EL_URI_QUERY_STRING_8): STRING_32
		do
			Result := url.decoded_32
		end
end
