note
	description: "Summary description for {EL_HTTP_PARAMETER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-02 12:25:22 GMT (Friday 2nd March 2018)"
	revision: "4"

deferred class
	EL_HTTP_PARAMETER

feature -- Basic operations

	extend (table: EL_URL_QUERY_HASH_TABLE)
		deferred
		end

end
