note
	description: "[
		Thread that applies the set `routine' and then waits for a `resume' prompt to do another one.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-06 11:56:48 GMT (Friday 6th October 2017)"
	revision: "2"

class
	EL_WORK_DISTRIBUTION_THREAD

inherit
	EL_CONTINUOUS_ACTION_THREAD
		redefine
			make_default, stop
		end

	EL_SUSPENDABLE
		redefine
			make_default, on_suspension
		end

create
	make

feature {NONE} -- Initialization

	make (a_distributer: like distributer; a_routine: like routine; a_index: like index)
		do
			make_default
			distributer := a_distributer; routine := a_routine; index := a_index
		end

	make_default
		do
			Precursor {EL_SUSPENDABLE}
			Precursor {EL_CONTINUOUS_ACTION_THREAD}
		end

feature -- Access

	index: INTEGER
		-- index of current thread in list: {EL_WORK_DISTRIBUTER}.threads

	routine: ROUTINE

feature -- Basic operations

	loop_action
			--
		do
			routine.apply
			suspend
		end

	stop
		do
			Precursor
			if is_suspended then
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
			distributer.on_applied (Current)
		end

feature {NONE} -- Internal attributes

	distributer: EL_WORK_DISTRIBUTER [ROUTINE]

end
