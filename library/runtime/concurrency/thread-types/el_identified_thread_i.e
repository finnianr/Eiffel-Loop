note
	description: "[
		Abstract interface to a thread conforming to [$source IDENTIFIED] and [$source EL_NAMED_THREAD]
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "9"

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
						[$source EL_DORMANT_ACTION_LOOP_THREAD]*
							[$source EL_REGULAR_INTERVAL_EVENT_PRODUCER]
						[$source EL_RHYTHMIC_ACTION_THREAD]*
							[$source EL_TIMED_COUNT_PRODUCER]
							[$source EL_TIMEOUT]
						[$source EL_CONSUMER_THREAD]* [P]
							[$source EL_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER]*
							[$source EL_MANY_TO_ONE_CONSUMER_THREAD]* [P]
							[$source EL_ACTION_ARGUMENTS_CONSUMER_THREAD] [ARGS -> [$source TUPLE] create default_create end]
								[$source EL_BATCH_FILE_PROCESSING_THREAD]*
									[$source EL_LOGGED_BATCH_FILE_PROCESSING_THREAD]*
							[$source EL_COUNT_CONSUMER_THREAD]*
								[$source EL_TIMED_PROCEDURE_THREAD]
							[$source EL_PROCEDURE_CALL_CONSUMER_THREAD]
							[$source EL_DELEGATING_CONSUMER_THREAD] [P, T -> [$source EL_MANY_TO_ONE_CONSUMER_THREAD [P]] create make end]
					[$source EL_WORKER_THREAD]
					[$source EL_FILE_PROCESS_THREAD]
						[$source EL_LOGGED_FILE_PROCESS_THREAD]
	]"
end