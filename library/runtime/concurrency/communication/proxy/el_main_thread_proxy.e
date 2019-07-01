note
	description: "[
		Proxy object to (asynchronously) call procedures of BASE_TYPE from an external thread (non GUI thread)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "3"

class
	EL_MAIN_THREAD_PROXY [G]

inherit
	ANY
	
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

	call (procedure: PROCEDURE)
			-- Asynchronously call procedure
		do
			main_thread_event_request_queue.put_action (procedure)
		end

	target: G

end
