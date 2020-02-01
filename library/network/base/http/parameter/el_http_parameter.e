note
	description: "Http parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-01 10:02:48 GMT (Saturday 1st February 2020)"
	revision: "8"

deferred class
	EL_HTTP_PARAMETER

feature -- Basic operations

	extend (table: EL_URL_QUERY_ZSTRING_HASH_TABLE)
		deferred
		end

end
