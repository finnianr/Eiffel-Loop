note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-05-30 8:17:41 GMT (Thursday 30th May 2013)"
	revision: "2"

class
	EL_SHARED_THREAD_MANAGER

feature -- Access

	Thread_manager: EL_THREAD_MANAGER
			--
		once ("PROCESS")
			create Result
		end

end
