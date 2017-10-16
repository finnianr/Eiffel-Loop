note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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