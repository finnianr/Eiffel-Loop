note
	description: "Summary description for {EL_REMOTE_CALL_REQUEST_DELEGATING_CONSUMER_THREAD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_REMOTE_CALL_REQUEST_DELEGATING_CONSUMER_THREAD

inherit
	EL_DELEGATING_CONSUMER_THREAD [EL_BYTE_COUNTING_NETWORK_STREAM_SOCKET, EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLING_THREAD]
		rename
			product_queue as client_request_queue
		redefine
			create_consumer_delegate, log_name, is_visible_in_console, prompt
		end

create
	make

feature -- Element change

	set_routine_call_event_listener (a_routine_call_event_listener: like routine_call_event_listener)
			--
		do
			routine_call_event_listener := a_routine_call_event_listener
		end

feature {NONE} -- Implementation

	create_consumer_delegate: EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLING_THREAD
			--
		do
			create Result.make (Current, client_request_queue.available_consumers)
			Result.set_client_request_handler (create {EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER}.make)
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

	routine_call_event_listener: EL_ROUTINE_CALL_SERVICE_EVENT_LISTENER

feature {NONE} -- Constants

	Log_name: STRING = "Request delegator"

	Is_visible_in_console: BOOLEAN = true

end
