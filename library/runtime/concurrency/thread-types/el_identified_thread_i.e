note
	description: "Summary description for {EL_IDENTIFIED_THREAD_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-28 11:52:08 GMT (Sunday 28th August 2016)"
	revision: "2"

deferred class
	EL_IDENTIFIED_THREAD_I

inherit
	IDENTIFIED

	EL_NAMED_THREAD
		undefine
			copy, is_equal
		end

convert
	thread_id: {POINTER}

feature -- Access

	thread_id: POINTER
			--
		deferred
		end

end
