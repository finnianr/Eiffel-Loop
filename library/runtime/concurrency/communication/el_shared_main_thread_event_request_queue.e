note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "2"

class
	EL_SHARED_MAIN_THREAD_EVENT_REQUEST_QUEUE

create
	default_create

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

	main_thread_event_request_queue_cell: CELL [EL_MAIN_THREAD_EVENT_REQUEST_QUEUE]
			--
		once ("PROCESS")
			create Result.put (create {EL_DEFAULT_MAIN_THREAD_EVENT_REQUEST_QUEUE})
		end

end
