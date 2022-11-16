note
	description: "Hash table of URL query string name-value pairs"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "16"

class
	EL_URI_QUERY_STRING_8_HASH_TABLE

inherit
	EL_URI_QUERY_HASH_TABLE [STRING_8]

create
	make_equal, make_url, make_uri, make_default

feature {NONE} -- Implementation

	decoded_string (url: EL_URI_QUERY_STRING_8): STRING_8
		do
			Result := url.decoded_8
		end
end