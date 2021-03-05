note
	description: "Event notification abstraction"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-11 16:26:42 GMT (Saturday 11th January 2020)"
	revision: "3"

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
				[$source EL_CONSUMER_MAIN_THREAD]* [P]
					[$source EL_TUPLE_CONSUMER_MAIN_THREAD] [OPEN_ARGS -> [$source TUPLE] create default_create end]
					[$source EL_PROCEDURE_CALL_CONSUMER_MAIN_THREAD] [OPEN_ARGS -> [$source TUPLE] create default_create end]
					[$source EL_MAIN_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER]*
					[$source EL_COUNT_CONSUMER_MAIN_THREAD]*
						[$source EL_TIMED_PROCEDURE_MAIN_THREAD] [BASE_TYPE, OPEN_ARGS -> [$source TUPLE] create default_create end]
				[$source EL_DELEGATING_CONSUMER_THREAD] [P, CONSUMER_TYPE -> [$source EL_MANY_TO_ONE_CONSUMER_THREAD [P]] create make end]
				[$source EL_EVENT_LISTENER_MAIN_THREAD_PROXY]
				[$source EL_EVENT_LISTENER_LIST]
	]"
end
