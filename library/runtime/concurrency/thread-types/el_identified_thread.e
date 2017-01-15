note
	description: "Summary description for {EL_IDENTIFIED_THREAD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-11-07 14:38:04 GMT (Monday 7th November 2016)"
	revision: "2"

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
			stop; join
			Previous_call_is_blocking_thread
-- THREAD WAITING

		end

	join
		do
			thread.join
		end

feature {NONE} -- Internal attributes

	thread: WORKER_THREAD

	internal_name: detachable like name

end
