note
	description: "Http parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "7"

deferred class
	EL_HTTP_PARAMETER

feature -- Basic operations

	extend (table: EL_URL_QUERY_HASH_TABLE)
		deferred
		end

end
