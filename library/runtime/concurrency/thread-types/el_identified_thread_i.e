note
	description: "Abstract interface to a thread identified by `thread_id'"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-04 15:35:16 GMT (Thursday 4th March 2021)"
	revision: "7"

deferred class
	EL_IDENTIFIED_THREAD_I

inherit
	IDENTIFIED

	EL_NAMED_THREAD
		undefine
			copy, is_equal
		end

convert
	thread_id: {POINTER}

feature -- Access

	thread_id: POINTER
			--
		deferred
		end

note
	descendants: "[
			EL_IDENTIFIED_THREAD_I*
				[$source EL_IDENTIFIED_MAIN_THREAD]
				[$source EL_IDENTIFIED_THREAD]*
					[$source EL_LOGGED_IDENTIFIED_THREAD]*
						[$source SIMPLE_SERVER_THREAD]
						[$source EROS_SERVER_THREAD]
					[$source EL_CONTINUOUS_ACTION_THREAD]*
						[$source EL_WORK_DISTRIBUTION_THREAD]
						[$source EL_CONSUMER_THREAD]* [P]
							[$source EL_DELEGATING_CONSUMER_THREAD] [P, [$source CONSUMER_TYPE] -> [$source EL_MANY_TO_ONE_CONSUMER_THREAD] [P] create make end]
							[$source EL_MANY_TO_ONE_CONSUMER_THREAD]* [P]
							[$source EL_PROCEDURE_CALL_CONSUMER_THREAD] [OPEN_ARGS -> [$source TUPLE] create default_create end]
							[$source EL_TUPLE_CONSUMER_THREAD] [OPEN_ARGS -> [$source TUPLE] create default_create end]
						[$source EL_DORMANT_ACTION_LOOP_THREAD]*
						[$source EL_RHYTHMIC_ACTION_THREAD]*
					[$source EL_WORKER_THREAD]
	]"
end