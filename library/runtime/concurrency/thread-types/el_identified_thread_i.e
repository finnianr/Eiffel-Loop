note
	description: "[
		Abstract interface to a thread conforming to ${IDENTIFIED} and ${EL_NAMED_THREAD}
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "10"

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
				${EL_IDENTIFIED_MAIN_THREAD}
				${EL_IDENTIFIED_THREAD}*
					${EL_LOGGED_IDENTIFIED_THREAD}*
						${SIMPLE_SERVER_THREAD}
						${EROS_SERVER_THREAD}
					${EL_CONTINUOUS_ACTION_THREAD}*
						${EL_WORK_DISTRIBUTION_THREAD}
						${EL_DORMANT_ACTION_LOOP_THREAD}*
							${EL_REGULAR_INTERVAL_EVENT_PRODUCER}
						${EL_RHYTHMIC_ACTION_THREAD}*
							${EL_TIMED_COUNT_PRODUCER}
							${EL_TIMEOUT}
						${EL_CONSUMER_THREAD}* [P]
							${EL_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER}*
							${EL_MANY_TO_ONE_CONSUMER_THREAD}* [P]
							${EL_ACTION_ARGUMENTS_CONSUMER_THREAD} [ARGS -> ${TUPLE} create default_create end]
								${EL_BATCH_FILE_PROCESSING_THREAD}*
									${EL_LOGGED_BATCH_FILE_PROCESSING_THREAD}*
							${EL_COUNT_CONSUMER_THREAD}*
								${EL_TIMED_PROCEDURE_THREAD}
							${EL_PROCEDURE_CALL_CONSUMER_THREAD}
							${EL_DELEGATING_CONSUMER_THREAD} [P, T -> ${EL_MANY_TO_ONE_CONSUMER_THREAD [P]} create make end]
					${EL_WORKER_THREAD}
					${EL_FILE_PROCESS_THREAD}
						${EL_LOGGED_FILE_PROCESS_THREAD}
	]"
end