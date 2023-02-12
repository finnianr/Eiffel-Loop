note
	description: "Include classes for compilation"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-27 8:03:48 GMT (Friday 27th January 2023)"
	revision: "5"

class
	COMPILED_CLASSES

feature {NONE} -- Compiled

	compile: TUPLE [
		EL_TEST_SET_BRIDGE, LIBGCC1, MY_WET_CLASS, MY_DRY_CLASS
	]
		do
			create Result
		end

	el_app_manage: TUPLE [
		EL_STANDARD_REMOVE_DATA_APP
	]
		-- app-manage.ecf
		do
			create Result
		end

	el_logging: TUPLE [
		EL_LOGGED_BATCH_FILE_PROCESSING_THREAD,
		EL_LOGGED_CONSUMER [ANY],
		EL_LOGGED_DELEGATING_CONSUMER_THREAD [ANY, EL_MANY_TO_ONE_CONSUMER_THREAD [ANY]],
		EL_LOGGED_FILE_PROCESS_THREAD,
		EL_LOGGED_FUNCTION_DISTRIBUTER [ANY],
		EL_LOGGED_MANY_TO_ONE_CONSUMER_THREAD [ANY],
		EL_LOGGED_PROCEDURE_DISTRIBUTER [ANY],
		EL_LOGGED_REGULAR_INTERVAL_EVENT_PRODUCER,
		EL_LOGGED_TIMEOUT
	]
		-- logging.ecf
		do
			create Result
		end

	el_thread: TUPLE [
		EL_BATCH_FILE_PROCESSING_THREAD,
		EL_COUNT_CONSUMER_THREAD,
		EL_COUNT_CONSUMER_MAIN_THREAD,
		EL_CONSUMER_MAIN_THREAD [ANY],
		EL_CONSUMER_THREAD [ANY],

		EL_DELEGATING_CONSUMER_THREAD [ANY, EL_MANY_TO_ONE_CONSUMER_THREAD [ANY]],
		EL_DORMANT_ACTION_LOOP_THREAD,
		EL_EVENT_LISTENER_MAIN_THREAD_PROXY,
		EL_FILE_PROCESS_THREAD,
		EL_INTERRUPTABLE_THREAD,

		EL_MAIN_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER,

		EL_PROCEDURE_CALL_CONSUMER_MAIN_THREAD,
		EL_PROCEDURE_CALL_CONSUMER_THREAD,
		EL_PROCEDURE_CALL_QUEUE,

		EL_REGULAR_INTERVAL_EVENT_CONSUMER,
		EL_REGULAR_INTERVAL_EVENT_PRODUCER,
		EL_RHYTHMIC_ACTION_THREAD,

		EL_SEPARATE_PROCEDURE [TUPLE],

		EL_THREAD_PROXY [ANY],
		EL_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER,
		EL_TIMED_COUNT_PRODUCER,
		EL_TIMED_PROCEDURE,
		EL_TIMED_PROCEDURE_MAIN_THREAD,
		EL_TIMEOUT,
		EL_TIMED_PROCEDURE_THREAD,

		EL_WORKER_THREAD
	]
		-- thread.ecf
		do
			create Result
		end

end