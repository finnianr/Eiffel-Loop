note
	description: "Hash table of URL query string name-value pairs"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-17 9:25:58 GMT (Friday 17th July 2020)"
	revision: "16"

class
	EL_URI_QUERY_STRING_32_HASH_TABLE

inherit
	EL_URI_QUERY_HASH_TABLE [STRING_32]

create
	make_equal, make_url, make_uri, make_default

feature {NONE} -- Implementation

	decoded_string (url: EL_URI_QUERY_STRING_8): STRING_32
		do
			Result := url.decoded_32 (True)
		end
end
