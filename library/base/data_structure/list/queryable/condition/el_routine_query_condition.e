note
	description: "A query condition that involves applying a routine agent to determine condition"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-05 15:53:06 GMT (Monday 5th November 2018)"
	revision: "1"

deferred class
	EL_ROUTINE_QUERY_CONDITION [G]

inherit
	EL_QUERY_CONDITION [G]

feature {NONE} -- Initialization

	make (a_routine: like routine)
		do
			create operands
			routine := a_routine
		end

feature -- Status query

	met (item: G): BOOLEAN
		-- True if `routine' applied to `item' is true
		do
			if operands_set then
				operands.put (item, 1)
			else
				operands := [item]
				routine.set_operands (operands)
			end
			routine.apply
		end

feature {NONE} -- Implementation

	operands_set: BOOLEAN

	operands: TUPLE [G]

	routine: ROUTINE [G]

end
