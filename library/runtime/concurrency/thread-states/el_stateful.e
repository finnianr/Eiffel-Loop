note
	description: "Stateful"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-06 12:23:34 GMT (Tuesday 6th April 2021)"
	revision: "7"

class
	EL_STATEFUL

feature -- Initialization

	make_default
			--
		do
			if not attached actual_state then
				create actual_state.make
			end
		end

feature -- Access

	state: INTEGER
			--
		do
			Result := actual_state.item
		end

feature -- Element change

	set_state (a_state: INTEGER)
			--
		do
			actual_state.set_item (a_state)
		end

feature {NONE} -- Implementation

	actual_state: EL_MUTEX_NUMERIC [INTEGER]

end