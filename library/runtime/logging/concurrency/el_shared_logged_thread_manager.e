note
	description: "Summary description for {EL_SHARED_LOGGED_THREAD_MANAGER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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