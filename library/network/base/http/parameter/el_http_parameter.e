note
	description: "Http parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "10"

deferred class
	EL_HTTP_PARAMETER

feature -- Basic operations

	extend (table: EL_URI_QUERY_ZSTRING_HASH_TABLE)
		deferred
		end

end