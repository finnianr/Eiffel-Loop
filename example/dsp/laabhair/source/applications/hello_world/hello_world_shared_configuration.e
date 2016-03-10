indexing
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	HELLO_WORLD_SHARED_CONFIGURATION

inherit
	LB_SHARED_CONFIGURATION	

feature -- Access

	Config: HELLO_WORLD_CONFIGURATION is
			--
		indexing
			once_status: global
		once
			create Result.make
		end
end
