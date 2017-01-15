note
	description: "[
		Object to distribute work of evaulating routines over a maximum number of threads
	]"
	instructions: "[
		The folowing steps apply to example code below:
		
		**1.** Declare an instance of `EL_WORK_DISTRIBUTER' with the base type of the routine target
			distributer: EL_WORK_DISTRIBUTER [like Current]
			
		**2.** Repeatedly call `wait_apply' with the routines you want to execute in parallel.
			distributer.wait_apply (agent my_routine)
			
		**3.** Call the `fill' routine at any time with a list to receive routines that have
		already been applied (executed)
		
		**4.** Finally call the `do_final' routine to wait for any remaining routines to finish executing and
		then wipe out all the threads. Applied routines that have not already been received can be accessed via
		the attribute `final_applied'
		
		**Example code**
		
		In the example the routine `do_calc' can be either a function or a procedure, it doesn't matter.
		
			distribute_work
				local
					distributer: EL_WORK_DISTRIBUTER [like Current]
					applied: ARRAYED_LIST [PROCEDURE [like Current, TUPLE]]
					i: INTEGER
				do
					create distributer.make (3) -- share work using a maximum of 3 threads
					create applied.make (10)
					
					from i := 1 until i > count loop
						-- call do_calc with a hypothetical argument
						distributer.wait_apply (agent do_calc (i))
						
						-- Optional calls to process already applied routines
						-- distributer.fill (applied)
						-- process_calc_result (applied)
						-- applied.wipe_out
						
						i := i + 1
					end

					distributer.do_final
			
					process_calc_result (distributer.final_applied)
				end
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-11-07 14:51:59 GMT (Monday 7th November 2016)"
	revision: "2"

class
	EL_WORK_DISTRIBUTER [BASE_TYPE]

inherit
	EL_SINGLE_THREAD_ACCESS

	EL_MODULE_EXECUTION_ENVIRONMENT

feature {NONE} -- Initialization

	make (maximum_thread_count: INTEGER)
		do
			make_default
			create pool.make (maximum_thread_count)
			create applied.make (20); create final_applied.make (0)
			create can_apply.make; create can_assign.make
		end

feature {NONE} -- Access

	final_applied: like applied
		-- contains applied routines after a call to `do_final'

feature -- Basic operations

	do_final
		-- wakeup all dormant threads and then wait until all have finished executing,
		-- before wiping out the thread pool. Make the applied routines available in `final_applied'
		do
			pool.do_all (agent {like pool.item}.stop)
			can_apply.broadcast
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
					if not pool.full and then pool.count = busy_count then
						create thread.make (Current)
						pool.extend (thread)
					end
					if attached unassigned_routine then
						-- BLOCKING call
						can_assign.wait (mutex) -- restriction temporarily ended while waiting
					end
					unassigned_routine := a_routine
					if attached thread as new_thread then
						new_thread.launch
					else
						can_apply.signal
					end
				end_restriction
			end
		end

feature -- Element change

	fill (a_applied: LIST [like unassigned_routine])
		-- fill the `a_applied' argument with already applied routines and wipe out `applied'
		-- does nothing if `applied' is empty
		do
			restrict_access
				if not applied.is_empty then
					applied.do_all (agent a_applied.extend)
					applied.wipe_out
				end
			end_restriction
		end

feature {EL_WORK_DISTRIBUTION_THREAD} -- Worker thread operations

	wait_to_apply
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
					can_assign.signal
				else
					-- BLOCKING call
					can_apply.wait (mutex) -- restriction temporarily ended while waiting
					-- `wait_to_apply' will now be called again due to continuous thread loop
				end
			end_restriction

			if attached l_routine as routine then
				routine.apply
				restrict_access
					busy_count := busy_count - 1
					applied.extend (routine)
				end_restriction
			end
		end

feature {NONE} -- Implementation

	busy_count: INTEGER
		-- count of threads in `pool' that are busy executing a routine

	unassigned_routine: detachable ROUTINE [BASE_TYPE, TUPLE]
		-- routine that is not yet assigned to any thread for execution

feature {NONE} -- Internal attributes

	applied: ARRAYED_LIST [like unassigned_routine]
		-- list of routines that have been applied since last call to `fill'

	can_apply: CONDITION_VARIABLE
		-- wait condition for `unassigned_routine' to become attached

	can_assign: CONDITION_VARIABLE
		-- wait condition for `unassigned_routine' to become detached

	pool: ARRAYED_LIST [EL_WORK_DISTRIBUTION_THREAD [BASE_TYPE]]
		-- pool of worker threads

end
