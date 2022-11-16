note
	description: "Stateful"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "8"

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