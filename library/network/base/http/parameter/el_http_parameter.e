note
	description: "Http parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-24 11:10:16 GMT (Sunday 24th May 2020)"
	revision: "9"

deferred class
	EL_HTTP_PARAMETER

feature -- Basic operations

	extend (table: EL_URI_QUERY_ZSTRING_HASH_TABLE)
		deferred
		end

end
