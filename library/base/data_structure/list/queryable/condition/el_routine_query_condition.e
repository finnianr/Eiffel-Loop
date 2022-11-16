note
	description: "A query condition that involves applying a routine agent to determine condition"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_ROUTINE_QUERY_CONDITION [G]

inherit
	EL_QUERY_CONDITION [G]

feature {NONE} -- Initialization

	make (a_routine: like routine)
		do
			routine := a_routine
		end

feature -- Status query

	met (item: G): BOOLEAN
		-- True if `routine' applied to `item' is true
		do
			routine.call (item)
		end

feature {NONE} -- Implementation

	routine: ROUTINE [G]

end