note
	description: "Event notification abstraction"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "5"

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
				[$source EL_COMMA_SEPARATED_WORDS_LIST]
				[$source EL_DEFAULT_EVENT_LISTENER]
				[$source EL_BYTE_COUNTING_LISTENER]*
					[$source EL_READ_BYTE_COUNTING_LISTENER]
					[$source EL_WRITTEN_BYTE_COUNTING_LISTENER]
				[$source EL_AGENT_EVENT_LISTENER]
				[$source EL_EVENT_LISTENER_PAIR]
				[$source EL_EVENT_LISTENER_LIST]
				[$source EL_CONSUMER_MAIN_THREAD]* [P]
					[$source EL_MAIN_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER]*
					[$source EL_COUNT_CONSUMER_MAIN_THREAD]*
						[$source EL_TIMED_PROCEDURE_MAIN_THREAD]
					[$source EL_PROCEDURE_CALL_CONSUMER_MAIN_THREAD]
					[$source EL_ACTION_ARGUMENTS_CONSUMER_MAIN_THREAD] [ARGS -> [$source TUPLE] create default_create end]
				[$source EL_EVENT_LISTENER_MAIN_THREAD_PROXY]
				[$source EL_DELEGATING_CONSUMER_THREAD] [P, T -> [$source EL_MANY_TO_ONE_CONSUMER_THREAD] [P] create make end]
					[$source EL_LOGGED_DELEGATING_CONSUMER_THREAD] [P, T -> [$source EL_MANY_TO_ONE_CONSUMER_THREAD] [P] create make end]

	]"
end