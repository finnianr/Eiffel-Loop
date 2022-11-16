note
	description: "Identified internal_thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "10"

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

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			create internal_thread.make (Current)
		end

feature -- Access

	thread_id: POINTER
			--
		do
			Result := internal_thread.thread_id
		end

feature -- Status query

	is_terminated: BOOLEAN
		do
			Result := internal_thread.terminated
		end

feature -- Basic operations

	execute
		deferred
		end

	join
		do
			internal_thread.join
		end

	launch
			--
		do
			launch_with_attributes (create {THREAD_ATTRIBUTES}.make)
		end

	launch_with_attributes (attribs: THREAD_ATTRIBUTES)
		do
			if not internal_thread.is_launchable then
				check
					previous_thread_terminated: internal_thread.terminated
				end
				create internal_thread.make (Current)
			end
			internal_thread.launch_with_attributes (attribs)
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

feature {EL_INTERNAL_THREAD} -- Implementation

	do_execution
			--
		do
			set_active
			execute
			set_stopped
		end

feature {NONE} -- Internal attributes

	internal_thread: EL_INTERNAL_THREAD

end