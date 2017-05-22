note
	description: "[
		Object to distribute work of evaulating routines over a maximum number of threads.
		
		It can be used directly, or by using one of it's two descendants `EL_FUNCTION_DISTRIBUTER'
		and `EL_PROCEDURE_DISTRIBUTER'.
		
		**Known issues**
		
		If you don't give sufficient work to the threads, the `do_final' call may hang.
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
	date: "2017-05-19 6:25:32 GMT (Friday 19th May 2017)"
	revision: "3"

class
	EL_WORK_DISTRIBUTER

inherit
	EL_SINGLE_THREAD_ACCESS

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make (maximum_thread_count: INTEGER)
		do
			make_default
			create pool.make (maximum_thread_count)
			create applied.make (20); create final_applied.make (0)
			create can_apply.make; create can_assign.make
			create thread_attributes.make
		end

feature -- Access

	maximum_busy_count: INTEGER
		-- for debugging purposes

feature -- Status change

	set_turbo
		-- set thread priority to maximum
		do
			thread_attributes.set_priority (thread_attributes.max_priority)
		end

	set_normal
		-- set thread priority to maximum
		do
			thread_attributes.set_priority (thread_attributes.default_priority)
		end

feature -- Basic operations

	do_final
		-- wakeup all dormant threads and then wait until all have finished executing,
		-- before wiping out the thread pool. Make the applied routines available in `final_applied'
		do
			restrict_access
				if attached unassigned_routine then
					-- BLOCKING call
					can_assign.wait (mutex) -- restriction temporarily ended while waiting
				end
--				lio.put_integer_field ("do_final busy_count", busy_count)
--				lio.put_new_line
			end_restriction

			pool.do_all (agent {like pool.item}.stop)
			can_assign.broadcast
			pool.do_all (agent {like pool.item}.join)
			pool.wipe_out
			final_applied := applied.twin
			applied.wipe_out
		end

	wait_apply (a_routine: like unassigned_routine)
		-- SYNCHRONOUS execution if `pool.capacity' = 1
		-- call apply on `a_routine' and add it to `applied' list

		-- ASYNCHRONOUS execution if `pool.capacity' > 1
		-- assign `a_routine' to an available thread for execution (`apply' called) waiting if necessary for one
		-- to become available. If there is no dormant thread available and the `pool' is not yet full,
		-- then add a new thread and launch it.
		require
			routine_has_no_open_arguments: a_routine.open_count = 0
		local
			thread: like pool.item
		do
			if pool.capacity = 1 then
				-- SYNCHRONOUS execution
				a_routine.apply
				applied.extend (a_routine)
			else
				-- ASYNCHRONOUS execution
				restrict_access
					if attached unassigned_routine then
						-- BLOCKING call
						can_assign.wait (mutex) -- restriction temporarily ended while waiting
					end
					unassigned_routine := a_routine
					if pool.count = busy_count and then not pool.full then
						create thread.make (Current)
						pool.extend (thread)
					end
				end_restriction

				if attached thread as new_thread then
					new_thread.launch_with_attributes (thread_attributes)
				else
					can_apply.signal
				end
			end
		end

	collect (list: LIST [like unassigned_routine])
		-- fill the `a_applied' argument with already applied routines and wipe out `applied'
		-- does nothing if `applied' is empty
		do
			restrict_access
				if not applied.is_empty then
					applied.do_all (agent list.extend)
					applied.wipe_out
				end
			end_restriction
		end

	collect_final (list: LIST [like unassigned_routine])
		-- fill the `a_applied' argument with already applied routines and wipe out `applied'
		-- does nothing if `applied' is empty
		do
			final_applied.do_all (agent list.extend)
			final_applied.wipe_out
		end

feature {EL_WORK_DISTRIBUTION_THREAD} -- Worker thread operations

	wait_to_apply (worker_mutex: MUTEX)
		-- if `unassigned_routine' is attached then apply it using current calling thread
		-- or else wait for `unassigned_routine' to become attached
		local
			l_routine: like unassigned_routine
		do
			restrict_access
				if attached unassigned_routine as routine then
					-- found a routine to apply
					l_routine := routine
					unassigned_routine := Void
					busy_count := busy_count + 1
					maximum_busy_count := maximum_busy_count.max (busy_count)
				end
			end_restriction

			if attached l_routine as routine then
				can_assign.signal
				routine.apply
				restrict_access
					busy_count := busy_count - 1
					applied.extend (routine)
				end_restriction
			else
				worker_mutex.lock
					-- BLOCKING call
					can_apply.wait (worker_mutex) -- restriction temporarily ended while waiting
					-- `wait_to_apply' will now be called again due to continuous thread loop
				worker_mutex.unlock
			end
		end

feature {NONE} -- Implementation

	busy_count: INTEGER
		-- count of threads in `pool' that are busy executing a routine

	unassigned_routine: detachable ROUTINE
		-- routine that is not yet assigned to any thread for execution

feature {NONE} -- Internal attributes

	applied: ARRAYED_LIST [like unassigned_routine]
		-- list of routines that have been applied since last call to `fill'

	can_apply: CONDITION_VARIABLE
		-- wait condition for `unassigned_routine' to become attached

	can_assign: CONDITION_VARIABLE
		-- wait condition for `unassigned_routine' to become detached

	final_applied: like applied
		-- contains applied routines after a call to `do_final'

	pool: ARRAYED_LIST [EL_WORK_DISTRIBUTION_THREAD]
		-- pool of worker threads

	thread_attributes: THREAD_ATTRIBUTES

end
