note
	description: "Http name value parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-16 16:57:07 GMT (Sunday 16th July 2023)"
	revision: "11"

class
	EL_HTTP_NAME_VALUE_PARAMETER

inherit
	EL_HTTP_PARAMETER
		rename
			extend as extend_table
		end

create
	make

feature {NONE} -- Initialization

	make (a_name: READABLE_STRING_GENERAL; a_value: like value)
		do
			create name.make_from_general (a_name); value := a_value
		end

feature -- Access

	name: ZSTRING

	value: ZSTRING

feature {EL_HTTP_PARAMETER} -- Implementation

	extend_table (table: EL_URI_QUERY_ZSTRING_HASH_TABLE)
		do
			table.set_string (name, value)
		end
end