note
	description: "Http parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:21 GMT (Saturday 19th May 2018)"
	revision: "5"

deferred class
	EL_HTTP_PARAMETER

feature -- Basic operations

	extend (table: EL_URL_QUERY_HASH_TABLE)
		deferred
		end

end
