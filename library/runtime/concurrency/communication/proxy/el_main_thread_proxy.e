note
	description: "[
		Proxy object to (asynchronously) call procedures of BASE_TYPE from an external thread (non GUI thread)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

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