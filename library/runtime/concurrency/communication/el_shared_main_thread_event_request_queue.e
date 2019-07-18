note
	description: "Shared main thread event request queue"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:25:37 GMT (Monday 1st July 2019)"
	revision: "5"

deferred class
	EL_SHARED_MAIN_THREAD_EVENT_REQUEST_QUEUE

inherit
	EL_ANY_SHARED

feature -- Access

	main_thread_event_request_queue: EL_MAIN_THREAD_EVENT_REQUEST_QUEUE
			--
		do
			Result := main_thread_event_request_queue_cell.item
		end

feature -- Element change

	set_main_thread_event_request_queue (a_event_request_queue: EL_MAIN_THREAD_EVENT_REQUEST_QUEUE)
			--
		do
			if attached {EL_DEFAULT_MAIN_THREAD_EVENT_REQUEST_QUEUE} main_thread_event_request_queue_cell.item
				as default_queue
			then
				a_event_request_queue.put_event_indexes (default_queue.pending_events)
			end
			main_thread_event_request_queue_cell.replace (a_event_request_queue)
		end

feature {NONE} -- Implementation

	Main_thread_event_request_queue_cell: CELL [EL_MAIN_THREAD_EVENT_REQUEST_QUEUE]
			--
		once ("PROCESS")
			create Result.put (create {EL_DEFAULT_MAIN_THREAD_EVENT_REQUEST_QUEUE})
		end

end
