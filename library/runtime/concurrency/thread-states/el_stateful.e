note
	description: "Summary description for {EL_STATEFUL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_STATEFUL

feature -- Initialization

	make
			--
		do
			create actual_state
		end

feature -- Access

	state: INTEGER
			--
		do
			Result := actual_state.value
		end

feature -- Element change

	set_state (a_state: INTEGER)
			--
		do
			actual_state.set_value (a_state)
		end

feature {NONE} -- Implementation

	actual_state: EL_SYNCHRONIZED_NUMERIC [INTEGER]

end
