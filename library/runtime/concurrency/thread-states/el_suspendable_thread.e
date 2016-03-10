note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-04-23 10:24:40 GMT (Thursday 23rd April 2015)"
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
			create blocked_thread.make
			create blocked_thread_mutex.make
		end

feature -- Basic operations

	resume
			-- unblock thread
		do
			blocked_thread.signal
		end

	suspend
			-- block thread and wait for signal to resume
		do
			set_state (State_suspended)
			blocked_thread_mutex.lock
			blocked_thread.wait (blocked_thread_mutex)
			blocked_thread_mutex.unlock
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

feature {NONE} -- Implementation

	blocked_thread: CONDITION_VARIABLE

	blocked_thread_mutex: MUTEX

invariant
	blocked_thread_not_void: blocked_thread /= Void

end
