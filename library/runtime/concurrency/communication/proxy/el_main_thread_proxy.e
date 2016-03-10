note
	description: "[
		Proxy object to (asynchronously) call procedures of BASE_TYPE from an external thread (non GUI thread)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_MAIN_THREAD_PROXY [G]

inherit
	EL_SHARED_MAIN_THREAD_EVENT_REQUEST_QUEUE

create
	make

feature {NONE} -- Initialization

	make (a_target: like target)
			-- 
		do
			target := a_target
		end

feature {NONE} -- Implementation

	call (procedure: PROCEDURE [ANY, TUPLE])
			-- Asynchronously call procedure
		do
			main_thread_event_request_queue.put_action (procedure)
		end

	target: G
	
end
