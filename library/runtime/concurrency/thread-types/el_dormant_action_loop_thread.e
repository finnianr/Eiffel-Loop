note
	description: "Thread that remains dormant until signalled to resume action loop"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-13 17:46:54 GMT (Wednesday 13th March 2013)"
	revision: "2"

deferred class
	EL_DORMANT_ACTION_LOOP_THREAD

inherit
	EL_CONTINUOUS_ACTION_THREAD
		rename
			loop_action as wait_to_resume_action_loop
		redefine
			stop, default_create
		end

	EL_SUSPENDABLE_THREAD
		rename
			make as make_suspendable,
			suspend as suspend_thread
		undefine
			default_create, is_equal, copy
		end

feature {NONE} -- Initialization

	default_create
			--
		do
			Precursor {EL_CONTINUOUS_ACTION_THREAD}
			make_suspendable
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
