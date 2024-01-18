note
	description: "Event notification abstraction"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-27 11:58:59 GMT (Monday 27th November 2023)"
	revision: "6"

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
				${EL_COMMA_SEPARATED_WORDS_LIST}
				${EL_DEFAULT_EVENT_LISTENER}
				${EL_BYTE_COUNTING_LISTENER}*
					${EL_READ_BYTE_COUNTING_LISTENER}
					${EL_WRITTEN_BYTE_COUNTING_LISTENER}
				${EL_AGENT_EVENT_LISTENER}
				${EL_EVENT_LISTENER_PAIR}
				${EL_EVENT_LISTENER_LIST}
				${EL_CONSUMER_MAIN_THREAD}* [P]
					${EL_MAIN_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER}*
					${EL_COUNT_CONSUMER_MAIN_THREAD}*
						${EL_TIMED_PROCEDURE_MAIN_THREAD}
					${EL_PROCEDURE_CALL_CONSUMER_MAIN_THREAD}
					${EL_ACTION_ARGUMENTS_CONSUMER_MAIN_THREAD} [ARGS -> ${TUPLE} create default_create end]
				${EL_EVENT_LISTENER_MAIN_THREAD_PROXY}
				${EL_DELEGATING_CONSUMER_THREAD} [P, T -> ${EL_MANY_TO_ONE_CONSUMER_THREAD} [P] create make end]
					${EL_LOGGED_DELEGATING_CONSUMER_THREAD} [P, T -> ${EL_MANY_TO_ONE_CONSUMER_THREAD} [P] create make end]

	]"
end