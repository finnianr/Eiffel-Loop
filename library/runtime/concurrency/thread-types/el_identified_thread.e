note
	description: "Summary description for {EL_IDENTIFIED_THREAD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-03 12:19:44 GMT (Sunday 3rd July 2016)"
	revision: "1"

deferred class
	EL_IDENTIFIED_THREAD

inherit
	EL_STOPPABLE_THREAD
		redefine
			make_default, name
		end

	EL_IDENTIFIED_THREAD_I
		undefine
			is_equal, copy
		redefine
			name
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

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			create thread.make (agent execute_thread)
		end

feature -- Access

	thread_id: POINTER
			--
		do
			Result := thread.thread_id
		end

feature -- Access

	name: ZSTRING
		do
			if attached internal_name as l_name then
				Result := l_name
			else
				Result := Precursor
			end
		end

feature -- Element change

	set_name (a_name: like name)
		do
			internal_name := a_name
		end

feature -- Basic operations

	execute
		deferred
		end

	execute_thread
			--
		do
			set_active
			execute
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

feature {NONE} -- Internal attributes

	thread: WORKER_THREAD

	internal_name: detachable like name

end