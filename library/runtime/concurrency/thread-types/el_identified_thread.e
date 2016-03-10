note
	description: "Summary description for {EL_IDENTIFIED_THREAD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-20 8:16:41 GMT (Wednesday 20th May 2015)"
	revision: "3"

deferred class
	EL_IDENTIFIED_THREAD

inherit
	EL_STOPPABLE_THREAD
		redefine
			make_default
		end

	EL_IDENTIFIED_THREAD_I
		undefine
			is_equal, copy
		end

	EL_THREAD_CONSTANTS
		undefine
			is_equal, copy
		end

	EL_THREAD_DEVELOPER_CLASS
		undefine
			is_equal, copy
		end

	EL_MODULE_EXECUTION_ENVIRONMENT
		undefine
			is_equal, copy
		end

	EL_MODULE_LOG_MANAGER
		undefine
			is_equal, copy
		end

	EL_MODULE_LOG
		undefine
			is_equal, copy
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			create thread.make (agent execute_thread)
		end

feature -- Access

	log_name: STRING
			--
		do
			Result := default_log_name
		end

	thread_id: POINTER
			--
		do
			Result := thread.thread_id
		end

feature -- Basic operations

	execute
		deferred
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

	launch
			--
		do
			if not thread.is_launchable then
				check
					previous_thread_terminated: thread.terminated
				end
				create thread.make (agent execute_thread)
			end
			thread.launch
		end

	log_stopping
		local
			l_count, checks_per_2_secs: INTEGER
		do
			checks_per_2_secs := (2000 / Check_stopped_interval_ms).rounded
			from until is_stopped loop
				sleep (Check_stopped_interval_ms)
				l_count := l_count + 1
				if l_count \\  checks_per_2_secs = 0 then
					log_or_io.put_labeled_string ("Stopping", log_name)
					log_or_io.put_new_line
				end
			end
		end

	sleep (millisecs: INTEGER)
			--
		do
			Execution_environment.sleep (millisecs)
		end

	sleep_nanosecs (nanosecs: INTEGER_64)
			--
		do
			Execution_environment.sleep_nanosecs (nanosecs)
		end

	sleep_secs (secs: INTEGER)
			--
		do
			sleep (secs * 1000)
		end

	wait_to_stop
			--
		do
			stop
			thread.join
			Previous_call_is_blocking_thread
-- THREAD WAITING

		end

feature -- Status query

	is_visible_in_console: BOOLEAN
			-- is logging output visible in console
			-- Override to true if thread makes any reference to log object
		do
			Result := false
		end

feature {NONE} -- Implementation

	default_log_name: STRING
			--
		do
			Result := generating_type.name.as_lower
		end

	on_exit
			--
		do
		end

	thread: WORKER_THREAD

feature {NONE} -- Constants

	Check_stopped_interval_ms: INTEGER
			-- milliseconds between checking if thread is stopped
		once
			Result := 100
		end
end
