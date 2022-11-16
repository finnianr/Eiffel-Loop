note
	description: "Listener for routine call request handling events"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EROS_ROUTINE_CALL_SERVICE_EVENT_LISTENER

feature -- Basic operations

	called_routine (is_function: BOOLEAN)
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