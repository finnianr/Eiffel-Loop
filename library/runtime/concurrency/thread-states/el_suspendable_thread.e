note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-02 16:59:00 GMT (Monday 2nd October 2017)"
	revision: "2"

deferred class
	EL_SUSPENDABLE_THREAD

inherit
	EL_STATEFUL
		redefine
			make_default
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			create can_resume.make
			create can_resume_mutex.make
		end

feature -- Basic operations

	resume
			-- unblock thread
		do
			can_resume.signal
		end

	suspend
			-- block thread and wait for signal to resume
		do
			set_state (State_suspended)
			can_resume_mutex.lock
			on_suspension
			can_resume.wait (can_resume_mutex)
			can_resume_mutex.unlock
		end

feature -- Status query

	is_suspended: BOOLEAN
			--
		do
			Result := state = State_suspended
		end

feature {NONE} -- Constants

	State_suspended: INTEGER
			--
		deferred
		end

feature {NONE} -- Event handling

	on_suspension
		-- called just before suspension on condition variable `can_resume'
		do
		end

feature {NONE} -- Implementation

	can_resume: CONDITION_VARIABLE

	can_resume_mutex: MUTEX

end
