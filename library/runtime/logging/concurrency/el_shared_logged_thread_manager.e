note
	description: "Shared logged thread manager"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "3"

deferred class
	EL_SHARED_LOGGED_THREAD_MANAGER

inherit
	EL_SHARED_THREAD_MANAGER
		redefine
			new_manager
		end

feature {NONE} -- Status query

	is_thread_management_logged: BOOLEAN
		deferred
		end

feature {NONE} -- Factory

	new_manager: EL_THREAD_MANAGER
		do
			if is_thread_management_logged then
				create {EL_LOGGED_THREAD_MANAGER} Result
			else
				create Result
			end
		end

end