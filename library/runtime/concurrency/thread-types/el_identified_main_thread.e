note
	description: "Summary description for {EL_IDENTIFIED_MAIN_THREAD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-10-21 14:31:04 GMT (Monday 21st October 2013)"
	revision: "2"

class
	EL_IDENTIFIED_MAIN_THREAD

inherit
	EL_IDENTIFIED_THREAD_I

feature -- Access

	thread_id: POINTER
			--
		do
			Result := {THREAD_ENVIRONMENT}.current_thread_id
		end

end
