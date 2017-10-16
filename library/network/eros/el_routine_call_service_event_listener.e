note
	description: "Listener for routine call request handling events"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_ROUTINE_CALL_SERVICE_EVENT_LISTENER

feature -- Basic operations

	called_function
			--
		do
		end

	called_procedure
			--
		do
		end

	received_bytes (bytes: INTEGER_64)
			--
		do
		end

	sent_bytes (bytes: INTEGER_64)
			--
		do
		end

	routine_failed
			--
		do
		end

	add_connection
			--
		do
		end

	remove_connection
			--
		do
		end

end