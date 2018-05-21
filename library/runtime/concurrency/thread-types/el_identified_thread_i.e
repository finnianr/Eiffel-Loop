note
	description: "Identified thread i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "3"

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
