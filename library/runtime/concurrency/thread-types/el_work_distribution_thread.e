note
	description: "[
		Thread that applies the `routine' set by the `distributer' and then waits
		for a `resume' prompt to do another one.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-03 13:25:46 GMT (Tuesday 3rd October 2017)"
	revision: "1"

class
	EL_WORK_DISTRIBUTION_THREAD

inherit
	EL_CONTINUOUS_ACTION_THREAD
		redefine
			make_default, stop
		end

	EL_SUSPENDABLE_THREAD
		redefine
			make_default, on_suspension
		end

create
	make

feature {NONE} -- Initialization

	make (a_distributer: like distributer; a_routine: like routine)
		do
			make_default
			distributer := a_distributer; routine := a_routine
		end

	make_default
		do
			Precursor {EL_SUSPENDABLE_THREAD}
			Precursor {EL_CONTINUOUS_ACTION_THREAD}
		end

feature -- Basic operations

	loop_action
			--
		do
			routine.apply
			distributer.extend_applied (routine)
			suspend
			if not is_stopping then
				set_active
			end
		end

	stop
		local
			l_state: INTEGER
		do
			l_state := state
			Precursor
			if l_state = State_suspended then
				resume
			end
		end

feature -- Element change

	set_routine (a_routine: like routine)
		do
			routine := a_routine
		end

feature {NONE} -- Event handling

	on_suspension
		do
			distributer.on_thread_available
		end

feature {NONE} -- Internal attributes

	distributer: EL_WORK_DISTRIBUTER [ROUTINE]

	routine: ROUTINE

end
