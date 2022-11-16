note
	description: "[
		Object to add together the [$source NUMERIC] results of a function applied to a
		[$source CONTAINER [G]] list of items filtered by an optional query condition
		[$source EL_QUERY_CONDITION [G]].
	]"
	tests: "Class [$source CHAIN_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "15"

class
	EL_RESULT_SUMMATOR [G, N -> NUMERIC]

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

	sum (value: FUNCTION [G, N]): N
		-- sum of `value' function across all items of `chain'
		do
			Result := sum_meeting (value, create {EL_ANY_QUERY_CONDITION [G]})
		end

	sum_meeting (value: FUNCTION [G, N]; condition: EL_QUERY_CONDITION [G]): N
		-- sum of `value' function across all items of `chain' meeting `condition'
		require
			valid_value_function: container_item.is_valid_for (value)
		local
			l_sum: CELL [N]; n: N
		do
			create l_sum.put (n.zero)
			do_meeting (agent add_to_sum (l_sum, value, ?), condition)
			Result := l_sum.item
		end

feature {NONE} -- Implementation

	add_to_sum (a_sum: CELL [N]; value: FUNCTION [G, N]; item: G)
		do
			a_sum.replace (a_sum.item + value (item))
		end

feature {NONE} -- Internal attributes

	container: CONTAINER [G]

end