note
	description: "Remote call client connection queue"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "11"

class
	EROS_CALL_REQUEST_CLIENT_CONNECTION_QUEUE

inherit
	EL_ONE_TO_MANY_THREAD_PRODUCT_QUEUE [EL_STREAM_SOCKET, EROS_CALL_REQUEST_HANDLING_THREAD]
		rename
			make as make_connection_queue
		redefine
			delegator
		end

create
	make

feature {NONE} -- Initialization

	make (a_consumer_count_max: INTEGER; a_routine_call_event_listener: EROS_ROUTINE_CALL_SERVICE_EVENT_LISTENER)
			--
		do
			make_connection_queue (a_consumer_count_max)
			delegator.set_routine_call_event_listener (a_routine_call_event_listener)
		end

feature -- Access

	request_thread_count_max: INTEGER
			--
		do
			Result := all_consumers.capacity
		end

feature {EROS_CALL_REQUEST_CONNECTION_MANAGER_THREAD} -- Access

	delegator: EROS_CALL_REQUEST_DELEGATING_CONSUMER_THREAD

end