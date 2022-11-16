note
	description: "Shared main thread event request queue"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

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
			if attached {like new_default_queue} main_thread_event_request_queue as queue then
				a_event_request_queue.put_event_indexes (queue.pending_events)
			end
			main_thread_event_request_queue_cell.replace (a_event_request_queue)
		end

feature {NONE} -- Implementation

	new_default_queue: EL_DEFAULT_MAIN_THREAD_EVENT_REQUEST_QUEUE
		do
			create Result.make
		end

	Main_thread_event_request_queue_cell: CELL [EL_MAIN_THREAD_EVENT_REQUEST_QUEUE]
			--
		once ("PROCESS")
			create Result.put (new_default_queue)
		end

end