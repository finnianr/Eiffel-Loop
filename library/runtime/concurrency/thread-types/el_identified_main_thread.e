note
	description: "Summary description for {EL_IDENTIFIED_MAIN_THREAD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

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
