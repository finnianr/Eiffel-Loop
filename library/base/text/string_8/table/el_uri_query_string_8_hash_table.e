note
	description: "[
		Implementation of ${EL_URI_QUERY_HASH_TABLE} for strings of type ${STRING_8}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-23 7:43:03 GMT (Monday 23rd September 2024)"
	revision: "18"

class
	EL_URI_QUERY_STRING_8_HASH_TABLE

inherit
	EL_URI_QUERY_HASH_TABLE [STRING_8, EL_STRING_8_BUFFER]

create
	make_equal, make_url, make_uri, make_default

feature {NONE} -- Implementation

	decoded_string (url: EL_URI_QUERY_STRING_8): STRING_8
		do
			Result := url.decoded_8
		end
end