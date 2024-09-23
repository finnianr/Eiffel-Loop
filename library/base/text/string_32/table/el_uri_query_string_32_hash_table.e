note
	description: "[
		Implementation of ${EL_URI_QUERY_HASH_TABLE} for strings of type ${STRING_32}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-23 7:42:47 GMT (Monday 23rd September 2024)"
	revision: "19"

class
	EL_URI_QUERY_STRING_32_HASH_TABLE

inherit
	EL_URI_QUERY_HASH_TABLE [STRING_32, EL_STRING_32_BUFFER]

create
	make_equal, make_url, make_uri, make_default

feature {NONE} -- Implementation

	decoded_string (url: EL_URI_QUERY_STRING_8): STRING_32
		do
			Result := url.decoded_32 (True)
		end
end