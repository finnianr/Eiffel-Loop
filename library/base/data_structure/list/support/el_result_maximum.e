note
	description: "[
		Object to find the maximum ${NUMERIC} result value of a function applied to a
		${CONTAINER [G]} list of items filtered by an optional query condition
		${EL_QUERY_CONDITION [G]}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "17"

class
	EL_RESULT_MAXIMUM [G, N -> {NUMERIC, COMPARABLE}]

inherit
	EL_CONTAINER_STRUCTURE [G]
		rename
			current_container as container
		export
			{NONE} all
			{ANY} container_item
		end

create
	make

feature {NONE} -- Initialization

	make (a_container: like container)
		require
			numeric_is_expanded: ({N}).is_expanded
		do
			container := a_container
		end

feature -- Access

	maximum (value: FUNCTION [G, N]): N
		-- maximum of `value' function across all items of `chain'
		do
			Result := maximum_meeting (value, create {EL_ANY_QUERY_CONDITION [G]})
		end

	maximum_meeting (value: FUNCTION [G, N]; condition: EL_QUERY_CONDITION [G]): N
		-- maximum of `value' function across all items of `chain' meeting `condition'
		require
			valid_value_function: container_item.is_valid_for (value)
		local
			l_maximum: CELL [N]; n: N
		do
			create l_maximum.put (n.zero)
			do_meeting (agent set_maximum (l_maximum, value, ?), condition)
			Result := l_maximum.item
		end

feature {NONE} -- Implementation

	set_maximum (a_maximum: CELL [N]; value: FUNCTION [G, N]; item: G)
		do
			if value (item) > a_maximum.item then
				a_maximum.replace (value (item))
			end
		end

feature {NONE} -- Internal attributes

	container: CONTAINER [G]

end