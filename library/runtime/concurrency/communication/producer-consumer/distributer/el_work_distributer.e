note
	description: "[
		Object to distribute work of evaulating routines over a maximum number of threads.

		It can be used directly, or by using one of it's two descendants `[$source EL_FUNCTION_DISTRIBUTER]'
		and `[$source EL_PROCEDURE_DISTRIBUTER]'.
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
	EL_SINGLE_THREAD_ACCESS

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	make (maximum_thread_count: INTEGER)
		do
			make_default
			create available.make (maximum_thread_count)
			create thread_available.make
			create threads.make (maximum_thread_count)
			create applied.make (20)
			create final_applied.make (0)
			create thread_attributes.make
		end

feature -- Access

	launched_count: INTEGER
		-- number of threads launched
		do
			Result := threads.count
		end

feature -- Status change

	set_normal_priority
		-- set thread priority to maximum
		do
			thread_attributes.set_priority (thread_attributes.default_priority)
		end

	set_max_priority
		-- set thread priority to maximum
		do
			thread_attributes.set_priority (thread_attributes.max_priority)
		end

feature -- Basic operations

	collect (list: LIST [R])
		-- fill the `list' argument with already applied routines and wipe out `applied'
		-- does nothing if `applied' is empty
		do
			restrict_access
				if not applied.is_empty then
					applied.do_all (agent list.extend)
					applied.wipe_out
				end
			end_restriction
		end

	collect_final (list: LIST [R])
		-- fill the `list' argument with already applied routines and wipe out `final_applied'
		-- does nothing if `final_applied' is empty
		do
			final_applied.do_all (agent list.extend)
			final_applied.wipe_out
		end

	do_final
		-- wait until all threads are available before stopping and joining all threads.
		-- Wipeout the thread pool and make the applied routines available in `final_applied'
		do
			restrict_access
				from until available.count = threads.count loop
					wait_until (thread_available)
				end
			end_restriction
			collect (final_applied)

			threads.do_all (agent {like threads.item}.wait_to_stop)
			threads.wipe_out
			available.wipe_out
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
		local
			thread: like threads.item; index: INTEGER
		do
			if threads.capacity = 0 then
				-- SYNCHRONOUS execution
				routine.apply
				applied.extend (routine)
			else
				restrict_access
					if not available.is_empty then
						index := available.item
						available.remove

					elseif threads.full then
						wait_until (thread_available)
						index := available.item
						available.remove
					end
				end_restriction
				if index = 0 then
					-- launch a new worker thread
					create thread.make (Current, routine, threads.count + 1)
					thread.launch_with_attributes (thread_attributes)
					threads.extend (thread)
				else
					thread := threads [index]
					thread.set_routine (routine)
					thread.resume
				end
			end
		end

feature {EL_WORK_DISTRIBUTION_THREAD} -- Event handling

	on_applied (thread: like threads.item)
		do
			restrict_access
				if attached {R} thread.routine as r then
					applied.extend (r)
				end
				available.put (thread.index)
			end_restriction
			thread_available.signal
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

	threads: ARRAYED_LIST [EL_WORK_DISTRIBUTION_THREAD]
		-- pool of worker threads

end
