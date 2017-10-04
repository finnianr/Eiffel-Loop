note
	description: "[
		Object to distribute work of evaulating routines over a maximum number of threads.

		It can be used directly, or by using one of it's two descendants `EL_FUNCTION_DISTRIBUTER'
		and `EL_PROCEDURE_DISTRIBUTER'.
	]"
	instructions: "[
		Use the class in the following way:
		
		**1.** Declare an instance of `EL_WORK_DISTRIBUTER'
			
		**2.** Repeatedly call `wait_apply' with the routines you want to execute in parallel.
			distributer.wait_apply (agent my_routine)
			
		**3.** Call the `collect' routine at any time with a list to receive routines that have
		already been applied (executed)
		
		**4.** Call the `do_final' routine to wait for any remaining routines to finish executing and
		then wipe out all the threads. 
		
		**5.** Collect any remaining results with a call to `collect_final'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-03 13:25:46 GMT (Tuesday 3rd October 2017)"
	revision: "1"

class
	EL_WORK_DISTRIBUTER [R -> ROUTINE]

inherit
	EL_THREAD_ACCESS

	EL_MODULE_LIO

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	make (maximum_thread_count: INTEGER)
		do
			create available_count.make (maximum_thread_count)
			create thread_available.make
			create threads.make (maximum_thread_count)
			create applied.make (new_routine_list (20))
			create final_applied.make (0)
			create thread_attributes.make

			create mutex.make
		end

feature -- Access

	maximum_busy_count: INTEGER
		-- for debugging purposes

feature -- Status change

	set_normal
		-- set thread priority to maximum
		do
			thread_attributes.set_priority (thread_attributes.default_priority)
		end

	set_turbo
		-- set thread priority to maximum
		do
			thread_attributes.set_priority (thread_attributes.max_priority)
		end

feature -- Basic operations

	collect (list: LIST [R])
		-- fill the `list' argument with already applied routines and wipe out `applied'
		-- does nothing if `applied' is empty
		local
			l_applied: like applied.item
		do
			restrict_access (applied)
				l_applied := applied.item
				if not l_applied.is_empty then
					l_applied.do_all (agent list.extend)
					l_applied.wipe_out
				end
			end_restriction (applied)
		end

	collect_final (list: LIST [R])
		-- fill the `list' argument with already applied routines and wipe out `final_applied'
		-- does nothing if `final_applied' is empty
		do
			final_applied.do_all (agent list.extend)
			final_applied.wipe_out
		end

	do_final
		-- wait until all threads are available before stopping all threads.
		-- Wipeout the thread pool and make the applied routines available in `final_applied'
		do
			if threads.for_all (agent {like threads.item}.is_suspended) then
				collect (final_applied)
				threads.do_all (agent {like threads.item}.wait_to_stop)
				threads.wipe_out
			else
				wait_until_available
				do_final
			end
		end

	wait_apply (routine: R)
		-- SYNCHRONOUS execution if `threads.capacity' = 0
		-- call apply on `routine' and add it to `applied' list

		-- ASYNCHRONOUS execution if `pool.capacity' >= 1
		-- assign `routine' to an available thread for execution, waiting if necessary for one
		-- to become available. If there is no suspended thread available and the `threads' pool is not yet full,
		-- then add a new thread and launch it.
		require
			routine_has_no_open_arguments: routine.open_count = 0
		do
			if threads.capacity = 0 then
				-- SYNCHRONOUS execution
				routine.apply
				restrict_access (applied)
					applied.item.extend (routine)
				end_restriction (applied)
			else
				available_count.wait -- Wait for at least one thread to become available
				wait_half_millisec -- Wait 0.5 millisecs for thread to go into suspension

				-- Assign `routine' to a thread
				threads.find_first (True, agent {like threads.item}.is_suspended)
				if threads.exhausted then
					threads.extend (create {like threads.item}.make (Current, routine))
					threads.last.launch_with_attributes (thread_attributes)
					maximum_busy_count := maximum_busy_count.max (threads.count)
				else
					threads.item.set_routine (routine)
					threads.item.resume
				end
			end
		end

feature {EL_WORK_DISTRIBUTION_THREAD} -- Implementation

	on_thread_available
		do
			available_count.post
			thread_available.signal
			-- requires 0.5 millisec for calling thread to go into suspension
		end

	extend_applied (routine: R)
		-- apply next routine in queue

		do
			if attached {R} routine as r then
				restrict_access (applied)
					applied.item.extend (r)
				end_restriction (applied)
			end
		end

	wait_until_available
			-- Wait until a thread becomes available
		do
			mutex.lock
				thread_available.wait (mutex)
			mutex.unlock
			wait_half_millisec -- Wait 0.5 millisecs for thread to go into suspension
		end

	wait_half_millisec
		do
			Execution_environment.sleep_nanosecs (500_000)
		end

feature {NONE} -- Factory

	new_routine_list (n: INTEGER): ARRAYED_LIST [R]
		do
			create Result.make (n)
		end

feature {NONE} -- Internal attributes

	applied: EL_MUTEX_REFERENCE [like new_routine_list]
		-- list of routines that have been applied since last call to `fill'

	available_count: SEMAPHORE

	final_applied: like new_routine_list
		-- contains applied routines after a call to `do_final'

	mutex: MUTEX
		-- mutex for condition variables

	threads: EL_ARRAYED_LIST [EL_WORK_DISTRIBUTION_THREAD]
		-- pool of worker threads

	thread_attributes: THREAD_ATTRIBUTES

	thread_available: CONDITION_VARIABLE
		-- `true' if at least one thread is in a suspended state

end
