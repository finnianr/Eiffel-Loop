note
	description: "A query condition that involves applying a routine agent to determine condition"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-14 10:26:35 GMT (Wednesday 14th November 2018)"
	revision: "3"

class
	EL_ROUTINE_QUERY_CONDITION [G]

inherit
	EL_QUERY_CONDITION [G]

	EL_ROUTINE_APPLICATOR [G]
		rename
			make as make_applicator
		end

feature {NONE} -- Initialization

	make (a_routine: like routine)
		do
			routine := a_routine
			make_applicator
		end

feature -- Status query

	met (item: G): BOOLEAN
		-- True if `routine' applied to `item' is true
		do
			apply (routine, item)
		end

feature {NONE} -- Implementation

	routine: ROUTINE [G]

end
