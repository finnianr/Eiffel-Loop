note
	description: "Remote call request delegating consumer thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-08 15:47:13 GMT (Monday 8th March 2021)"
	revision: "9"

class
	EROS_CALL_REQUEST_DELEGATING_CONSUMER_THREAD

inherit
	EL_LOGGED_DELEGATING_CONSUMER_THREAD [EL_STREAM_SOCKET, EROS_CALL_REQUEST_HANDLING_THREAD]
		rename
			product_queue as client_request_queue
		redefine
			make, new_consumer_delegate, prompt
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			set_name ("Request delegator")
		end
feature -- Element change

	set_routine_call_event_listener (a_routine_call_event_listener: like routine_call_event_listener)
			--
		do
			routine_call_event_listener := a_routine_call_event_listener
		end

feature {NONE} -- Implementation

	new_consumer_delegate: EROS_CALL_REQUEST_HANDLING_THREAD
			--
		do
			create Result.make (Current, client_request_queue.available_consumers)
			Result.set_client_request_handler (create {EROS_CALL_REQUEST_HANDLER}.make)
			Result.set_routine_call_event_listener (routine_call_event_listener)
			Result.set_log_name_suffix (client_request_queue.all_consumers.count + 1)
		end

	prompt
			--
		local
			current_state: INTEGER
		do
			current_state := state
			Precursor
			if current_state /= State_stopping then
				routine_call_event_listener.add_connection
			end
		end

	routine_call_event_listener: EROS_ROUTINE_CALL_SERVICE_EVENT_LISTENER

end