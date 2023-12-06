note
	description: "Http parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-06 11:07:58 GMT (Wednesday 6th December 2023)"
	revision: "11"

deferred class
	EL_HTTP_PARAMETER

inherit
	EL_CONVERTIBLE_TO_HTTP_PARAMETER

feature -- Access

	to_parameter: EL_HTTP_PARAMETER
		do
			Result := Current
		end

feature -- Basic operations

	add_to_table (table: EL_URI_QUERY_ZSTRING_HASH_TABLE)
		deferred
		end

	add_to_list (list: EL_HTTP_PARAMETER_LIST)
		do
			list.extend (Current)
		end
end