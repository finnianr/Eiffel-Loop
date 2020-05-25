note
	description: "Http name value parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-24 11:09:55 GMT (Sunday 24th May 2020)"
	revision: "9"

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

	make (a_name: like name; a_value: like value)
		do
			name := a_name; value := a_value
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
