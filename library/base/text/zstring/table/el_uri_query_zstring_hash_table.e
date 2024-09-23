note
	description: "[
		Implementation of ${EL_URI_QUERY_HASH_TABLE} for strings of type ${ZSTRING}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-23 7:43:21 GMT (Monday 23rd September 2024)"
	revision: "20"

class
	EL_URI_QUERY_ZSTRING_HASH_TABLE

inherit
	EL_URI_QUERY_HASH_TABLE [ZSTRING, EL_ZSTRING_BUFFER]

create
	default_create, make_equal, make_uri, make_url, make_default

feature {NONE} -- Implementation

	decoded_string (url: EL_URI_QUERY_STRING_8): ZSTRING
		do
			Result := url.decoded
		end
end