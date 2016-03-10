note
	description: "Summary description for {EL_HTTP_PARAMETER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-28 8:26:18 GMT (Thursday 28th May 2015)"
	revision: "5"

deferred class
	EL_HTTP_PARAMETER

feature -- Basic operations

	extend (table: EL_HTTP_HASH_TABLE)
		deferred
		end

end
