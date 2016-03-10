note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-04-23 10:20:42 GMT (Thursday 23rd April 2015)"
	revision: "2"

deferred class
	EL_STOPPABLE_THREAD

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
			set_stopped
		end

feature -- Status change

	stop, set_stopping
			-- Tell the thread to stop
		do
			set_state (State_stopping)
		end

	activate
			--
		do
			set_state (State_activating)
		end

feature -- Query status

	is_stopped: BOOLEAN
			--
		do
			Result := state = State_stopped
		end

	is_stopping: BOOLEAN
			--
		do
			Result := state = State_stopping
		end

	is_active: BOOLEAN
			--
		do
			Result := state = State_active
		end

	is_activating: BOOLEAN
			--
		do
			Result := state = State_activating
		end

feature -- Constants

	State_active: INTEGER
			--
		deferred
		end

	State_activating: INTEGER
			--
		deferred
		end

	State_stopped: INTEGER
			--
		deferred
		end

	State_stopping: INTEGER
			--
		deferred
		end

feature {NONE} -- Implementation

	set_stopped
			--
		do
			set_state (State_stopped)
		end

	set_active
			--
		do
			set_state (State_active)
		end

end
