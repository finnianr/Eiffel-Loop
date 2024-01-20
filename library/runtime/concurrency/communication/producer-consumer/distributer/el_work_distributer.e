note
	description: "[
		Object to distribute work of applying routine-agents over a fixed number of CPU processors (threads)
	]"
	descendants: "See end of class"
	instructions: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "13"

deferred class
	EL_WORK_DISTRIBUTER [G, R -> ROUTINE]

inherit
	EL_SINGLE_THREAD_ACCESS

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_SYSTEM

	EL_LAZY_ATTRIBUTE
		rename
			item as collection_list,
			new_item as new_collection_list,
			actual_item as actual_collection_list
		end

feature {NONE} -- Initialization

	make (maximum_cpu_percentage: INTEGER)
		-- make with maximum percentage of available CPU processors to use
		-- 0 % indicate a single threaded implementation of `wait_apply'
		require
			valid_percentage: 0 <= maximum_cpu_percentage and maximum_cpu_percentage <= 100
		do
			make_threads (System.scaled_processor_count (maximum_cpu_percentage))
		end

	make_threads (maximum_thread_count: INTEGER)
		do
			make_default
			create available.make (maximum_thread_count)
			create thread_available.make
			create pool.make (maximum_thread_count)
			create applied.make (20)
			create final_applied.make (0)
			create thread_attributes.make
		end

feature -- Access

	launched_count: INTEGER
		-- number of threads launched
		do
			Result := pool.count
		end

feature -- Status query

	is_finalized: BOOLEAN
		-- `True' if `do_final' has been called

feature -- Contract Support

	valid_routine (routine: R): BOOLEAN
		deferred
		end

feature -- Status change

	set_max_priority
		-- set thread priority to maximum
		do
			thread_attributes.set_priority (thread_attributes.max_priority)
		end

	set_normal_priority
		-- set thread priority to maximum
		do
			thread_attributes.set_priority (thread_attributes.default_priority)
		end

feature -- Basic operations

	collect (completed_list: LIST [G])
		--  collect the list of completed function results of type G from `applied' function list
		do
			if is_finalized then
				move (final_applied, completed_list)
				is_finalized := False
			else
				restrict_access
					move (applied, completed_list)
				end_restriction
			end
		end

	do_final
		-- wait until all threads are available before stopping and joining all threads.
		-- Wipeout the thread pool and make the applied routines available in `final_applied'
		do
			restrict_access
				from until available.count = pool.count loop
					wait_until_signaled (thread_available)
				end
				applied.do_all (agent final_applied.extend)
			end_restriction

			pool.do_all (agent {like pool.item}.wait_to_stop)
			is_finalized := True
			pool.wipe_out
			available.wipe_out
		end

	do_with_completed (action: PROCEDURE [G])
		do
			if attached collection_list as list then
				collect (list)
				list.do_all (action); list.wipe_out
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
			valid_routine: valid_routine (routine)
			routine_has_no_open_arguments: routine.open_count = 0
			not_finalized: not is_finalized
		local
			thread: like pool.item; index: INTEGER
		do
			if pool.capacity = 0 then
				-- SYNCHRONOUS execution
				routine.apply
				applied.extend (routine)
			else
				restrict_access
					if not available.is_empty then
						index := available.item
						available.remove

					elseif pool.full then
						wait_until_signaled (thread_available)
						index := available.item
						available.remove
					end
				end_restriction
				if index = 0 then
					-- launch a new worker thread
					create thread.make (Current, routine, pool.count + 1)
					thread.launch_with_attributes (thread_attributes)
					pool.extend (thread)
				else
					thread := pool [index]
					thread.set_routine (routine)
					thread.resume
				end
			end
		end

feature {EL_WORK_DISTRIBUTION_THREAD} -- Event handling

	on_applied (thread: like pool.item)
		do
			restrict_access
				if attached {R} thread.routine as r then
					applied.extend (r)
				end
				available.put (thread.index)
			end_restriction
			thread_available.signal
		end

feature {NONE} -- Implementation

	move (routines: like applied; completed_list: LIST [G])
		do
			from routines.start until routines.after loop
				completed_list.extend (new_completed (routines.item))
				routines.remove
			end
		end

	new_collection_list: ARRAYED_LIST [G]
		do
			create Result.make (10)
		end

	new_completed (routine: R): G
		deferred
		end

feature {NONE} -- Thread shared attributes

	applied: ARRAYED_LIST [R]
		-- list of routines that have been applied since last call to `fill'

	available: ARRAYED_STACK [INTEGER]
		-- indices of available suspended threads

	thread_available: CONDITION_VARIABLE
		-- `true' if at least one thread is in a suspended state

feature {NONE} -- Internal attributes

	final_applied: like applied
		-- contains applied routines after a call to `do_final'

	thread_attributes: THREAD_ATTRIBUTES

	pool: ARRAYED_LIST [EL_WORK_DISTRIBUTION_THREAD];
		-- pool of worker threads

note
	descendants: "[
			EL_WORK_DISTRIBUTER* [G, R -> ROUTINE]
				${EL_FUNCTION_DISTRIBUTER} [G]
					${EL_DISTRIBUTED_PROCEDURE_CALLBACK}
						${EIFFEL_CLASS_UPDATE_CHECKER}
						${EIFFEL_CLASS_PARSER}
				${EL_PROCEDURE_DISTRIBUTER} [G]
	]"
	instructions: "[
		**USAGE:**

		**1.** Declare an instance of a descendant ${EL_PROCEDURE_DISTRIBUTER} or ${EL_FUNCTION_DISTRIBUTER}.

		**2.** Repeatedly call `wait_apply' with the routines you want to execute in parallel.
			distributer.wait_apply (agent my_routine)

		**3.** Call the `collect' routine at any time with a list to receive routines that have
		already been applied (executed)

		**4.** Call the `do_final' routine to wait for any remaining routines to finish executing and
		then wipe out all the threads.

		**5.** Collect any remaining results with a call to `collect'

		Alternatively steps 3 and 5 can be replaced with a call to `do_with_completed'.
	]"

end