note
	description: "Thread that remains dormant until signalled to resume action loop"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-04-23 10:36:21 GMT (Thursday 23rd April 2015)"
	revision: "3"

deferred class
	EL_DORMANT_ACTION_LOOP_THREAD

inherit
	EL_CONTINUOUS_ACTION_THREAD
		rename
			loop_action as wait_to_resume_action_loop
		redefine
			stop, make_default
		end

	EL_SUSPENDABLE_THREAD
		rename
			suspend as suspend_thread
		undefine
			is_equal, copy
		redefine
			make_default
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor {EL_SUSPENDABLE_THREAD}
			Precursor {EL_CONTINUOUS_ACTION_THREAD}
			set_stopped
		end

feature -- Status settting

	stop
			-- stop thread and exit
		do
			set_state (State_stopping)
			resume -- To exit loop
			previous_call_is_thread_signal
-- THREAD SIGNAL
		end

	suspend
			-- become dormant after current action finishes
		do
			set_state (State_suspending)
		end

feature -- Status query

	is_suspending: BOOLEAN
			--
		do
			Result := state = State_suspending
		end

feature {NONE} -- Implementation

	wait_to_resume_action_loop
			--
		do
			if is_suspending then
				on_suspension
			end
			suspend_thread
			Previous_call_is_blocking_thread
-- THREAD WAITING

			if not is_stopping then
				on_resumption
				set_state (State_active)
				from until is_stopping or is_suspending loop
					do_action
				end
			end
		end

	on_resumption
			--
		do
		end

	on_suspension
			--
		do
		end

	do_action
			--
		deferred
		end

end
