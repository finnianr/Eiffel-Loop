note
	description: "Shared thread manager"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "4"

deferred class
	EL_SHARED_THREAD_MANAGER

inherit
	EL_ANY_SHARED

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
