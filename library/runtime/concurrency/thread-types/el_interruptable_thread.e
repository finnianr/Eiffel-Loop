note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_INTERRUPTABLE_THREAD

inherit
	EL_STATEFUL

	EL_THREAD_DEVELOPER_CLASS

feature -- Basic operations

	interrupt
			--
		do
			set_state (State_interrupted)
		end

	set_uninterrupted
			--
		do
			set_state (State_uninterrupted)
		end

feature -- Query status

	is_interrupted: BOOLEAN
			--
		do
			Result := state = State_interrupted
		end

feature {NONE} -- Constants

	State_interrupted: INTEGER
			--
		deferred
		end

	State_uninterrupted: INTEGER
			--
		deferred
		end

end
