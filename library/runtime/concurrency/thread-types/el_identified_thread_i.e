note
	description: "Summary description for {EL_IDENTIFIED_THREAD_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-03 5:39:07 GMT (Sunday 3rd July 2016)"
	revision: "3"

deferred class
	EL_IDENTIFIED_THREAD_I

inherit
	IDENTIFIED

	EL_NAMED_THREAD
		undefine
			copy, is_equal
		end

feature -- Access

	thread_id: POINTER
			--
		deferred
		end

end
