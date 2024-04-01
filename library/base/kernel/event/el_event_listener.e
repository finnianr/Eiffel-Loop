note
	description: "Event notification abstraction"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-01 15:37:27 GMT (Monday 1st April 2024)"
	revision: "8"

deferred class
	EL_EVENT_LISTENER

feature -- Basic operation

	notify
			--
		deferred
		end

feature -- Access

	listener_count: INTEGER
		-- number of active listeners
		do
			Result := 1
		end

note
	descendants: "[
			EL_EVENT_LISTENER*
				${EL_CONSUMER_MAIN_THREAD* [P]}
					${EL_COUNT_CONSUMER_MAIN_THREAD*}
						${EL_TIMED_PROCEDURE_MAIN_THREAD}
					${EL_MAIN_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER*}
					${EL_PROCEDURE_CALL_CONSUMER_MAIN_THREAD}
					${EL_ACTION_ARGUMENTS_CONSUMER_MAIN_THREAD [OPEN_ARGS -> TUPLE create default_create end]}
				${EL_DELEGATING_CONSUMER_THREAD [P, CONSUMER_TYPE -> EL_MANY_TO_ONE_CONSUMER_THREAD [P] create make end]}
					${EL_LOGGED_DELEGATING_CONSUMER_THREAD [P, CONSUMER_TYPE -> EL_MANY_TO_ONE_CONSUMER_THREAD [P] create make end]}
				${EL_EVENT_LISTENER_MAIN_THREAD_PROXY}
				${EL_EVENT_LISTENER_PAIR}
				${EL_COMMA_SEPARATED_WORDS_LIST}
				${EL_FILE_GENERAL_LINE_SOURCE* [S -> STRING_GENERAL create make end]}
					${EL_STRING_8_IO_MEDIUM_LINE_SOURCE}
					${EL_PLAIN_TEXT_LINE_SOURCE}
						${EL_ENCRYPTED_PLAIN_TEXT_LINE_SOURCE}
					${EL_ZSTRING_IO_MEDIUM_LINE_SOURCE}
				${EL_DEFAULT_EVENT_LISTENER}
				${EL_BYTE_COUNTING_LISTENER*}
					${EL_READ_BYTE_COUNTING_LISTENER}
					${EL_WRITTEN_BYTE_COUNTING_LISTENER}
				${EL_AGENT_EVENT_LISTENER}
				${EL_EVENT_LISTENER_LIST}
					${EL_EVENT_BROADCASTER}
	]"
end