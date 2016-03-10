note
	description: "Summary description for {EL_REMOTE_CALL_CLIENT_CONNECTION_QUEUE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-06 18:25:41 GMT (Thursday 6th June 2013)"
	revision: "2"

class
	EL_REMOTE_CALL_CLIENT_CONNECTION_QUEUE

inherit
	EL_ONE_TO_MANY_THREAD_PRODUCT_QUEUE [EL_BYTE_COUNTING_NETWORK_STREAM_SOCKET, EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLING_THREAD]
		rename
			make as make_connection_queue
		redefine
			delegator
		end

create
	make

feature {NONE} -- Initialization

	make (a_consumer_count_max: INTEGER; a_routine_call_event_listener: EL_ROUTINE_CALL_SERVICE_EVENT_LISTENER)
			--
		do
			make_connection_queue (a_consumer_count_max, create {EL_THREAD_MANAGER})
			delegator.set_routine_call_event_listener (a_routine_call_event_listener)
		end

feature -- Access

	request_thread_count_max: INTEGER
			--
		do
			Result := all_consumers.capacity
		end

feature {EL_REMOTE_CALL_CONNECTION_MANAGER_THREAD} -- Access

	delegator: EL_REMOTE_CALL_REQUEST_DELEGATING_CONSUMER_THREAD

end
