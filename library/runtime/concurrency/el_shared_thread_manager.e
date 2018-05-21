note
	description: "Shared thread manager"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:06 GMT (Saturday 19th May 2018)"
	revision: "3"

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