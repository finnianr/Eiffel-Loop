note
	description: "Summary description for {EL_IDENTIFIED_THREAD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-13 16:48:12 GMT (Wednesday 13th March 2013)"
	revision: "2"

deferred class
	EL_IDENTIFIED_THREAD

inherit
	EL_STOPPABLE_THREAD
		redefine
			default_create
		end

	EL_IDENTIFIED_THREAD_I
		undefine
			default_create, is_equal, copy
		end

	EL_THREAD_CONSTANTS
		undefine
			default_create, is_equal, copy
		end

	EL_THREAD_DEVELOPER_CLASS
		undefine
			default_create, is_equal, copy
		end

	EL_MODULE_EXECUTION_ENVIRONMENT
		undefine
			default_create, is_equal, copy
		end

	EL_MODULE_LOG_MANAGER
		undefine
			default_create, is_equal, copy
		end

feature {NONE} -- Initialization

	default_create
			--
		do
			Precursor {EL_STOPPABLE_THREAD}
			create thread.make (agent execute_thread)
		end

feature -- Access

	thread_id: POINTER
			--
		do
			Result := thread.thread_id
		end

	log_name: STRING
			--
		do
			Result := default_log_name
		end

feature -- Basic operations

	launch
			--
		do
			if not thread.is_launchable then
				check
					previous_thread_terminated: thread.terminated
				end
				create thread.make (agent execute)
			end
			thread.launch
		end

	execute_thread
			--
		do
			if is_visible_in_console then
				log_manager.add_visible_thread (Current, log_name)
			end
			set_active
			execute
			on_exit
			set_stopped
		end

	execute
		deferred
		end

	wait_to_stop
			--
		do
			stop
			thread.join
			Previous_call_is_blocking_thread
-- THREAD WAITING

		end

	sleep (millisecs: INTEGER)
			--
		do
			Execution_environment.sleep (millisecs)
		end

	sleep_secs (secs: INTEGER)
			--
		do
			sleep (secs * 1000)
		end

	sleep_nanosecs (nanosecs: INTEGER_64)
			--
		do
			Execution_environment.sleep_nanosecs (nanosecs)
		end

feature -- Status query

	is_visible_in_console: BOOLEAN
			-- is logging output visible in console
		do
			Result := false
		end

feature {NONE} -- Implementation

	on_exit
			--
		do
		end

	default_log_name: STRING
			--
		do
			Result := generating_type.name.as_lower
		end

	thread: WORKER_THREAD

end
