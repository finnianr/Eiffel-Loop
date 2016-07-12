note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-03 6:12:50 GMT (Sunday 3rd July 2016)"
	revision: "3"

deferred class
	EL_STOPPABLE_THREAD

inherit
	EL_STATEFUL
		redefine
			make_default
		end

	EL_NAMED_THREAD

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			set_stopped
		end

feature -- Status change

	activate
			--
		do
			set_state (State_activating)
		end

	stop, set_stopping
			-- Tell the thread to stop
		do
			set_state (State_stopping)
		end

feature -- Query status

	is_activating: BOOLEAN
			--
		do
			Result := state = State_activating
		end

	is_active: BOOLEAN
			--
		do
			Result := state = State_active
		end

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

feature -- Constants

	State_activating: INTEGER
			--
		deferred
		end

	State_active: INTEGER
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

feature {NONE} -- Event handler

	on_exit
			--
		do
		end

	on_start
		do
		end

feature {NONE} -- Implementation

	set_active
			--
		do
			set_state (State_active)
			on_start
		end

	set_stopped
			--
		do
			on_exit
			set_state (State_stopped)
		end

end
