note
	description: "One of query condition"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_ONE_OF_QUERY_CONDITION [G]

inherit
	EL_QUERY_CONDITION [G]

create
	make

feature {NONE} -- Initialization

	make (a_conditions: like conditions)
		do
			conditions := a_conditions
		end

feature -- Access

	met (item: G): BOOLEAN
		-- True if `item' meets at least one of the `conditions'
		do
			Result := across conditions as condition some
				condition.item.met (item)
			end
		end

feature {NONE} -- Implementation

	conditions: ARRAY [EL_QUERY_CONDITION [G]]

end