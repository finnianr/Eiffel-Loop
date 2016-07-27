note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-02 19:55:38 GMT (Saturday 2nd July 2016)"
	revision: "4"

class
	EL_SHARED_THREAD_MANAGER

feature {NONE} -- Factory

	new_manager: EL_THREAD_MANAGER
		do
			create Result
		end

feature {NONE} -- Constant

	Thread_manager: EL_THREAD_MANAGER
			--
		once ("PROCESS")
			Result := new_manager
		end

end