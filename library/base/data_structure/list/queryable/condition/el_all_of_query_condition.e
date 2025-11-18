note
	description: "[
		Query condition that matches all query conditions listed in `conditions'  array
		in a call to ${EL_CONTAINER_STRUCTURE [G]}.query
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-18 9:12:36 GMT (Tuesday 18th November 2025)"
	revision: "9"

class
	EL_ALL_OF_QUERY_CONDITION [G]

inherit
	EL_QUERY_CONDITION [G]

create
	make

feature {NONE} -- Initialization

	make (a_conditions: like conditions)
		do
			conditions := a_conditions
		end

feature -- Status query

	met (item: G): BOOLEAN
		-- True if `item' meets all of the `conditions'
		do
			Result := across conditions as condition all condition.item.met (item) end
		end

feature {NONE} -- Implementation

	conditions: ARRAY [EL_QUERY_CONDITION [G]]

end