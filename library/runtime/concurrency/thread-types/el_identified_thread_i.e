note
	description: "Summary description for {EL_IDENTIFIED_THREAD_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "2"

deferred class
	EL_IDENTIFIED_THREAD_I

inherit
	IDENTIFIED

feature -- Access

	thread_id: POINTER
			--
		deferred
		end

end
