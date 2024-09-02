note
	description: "[
		Object to add together the ${NUMERIC} results of a function applied to a
		${CONTAINER [G]} list of items filtered by an optional query condition
		${EL_QUERY_CONDITION [G]}.
	]"
	tests: "Class ${CONTAINER_STRUCTURE_TEST_SET}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-02 14:59:32 GMT (Monday 2nd September 2024)"
	revision: "19"

class
	EL_CONTAINER_ARITHMETIC [G, N -> NUMERIC]

inherit
	EL_CONTAINER_STRUCTURE [G]
		rename
			current_container as container
		export
			{NONE} all
			{ANY} container_item
		end

	EL_MODULE_EIFFEL

	REFLECTOR_CONSTANTS
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (a_container: like container)
		require
			N_is_expanded: ({N}).is_expanded
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
		do
			if attached {EL_NUMERIC_RESULT [N]} numeric_result as max then
				max.set_to_min_value
				do_meeting (agent set_maximum (max, value, ?), condition)
				Result := max.result_
			end
		end

	sum (value: FUNCTION [G, N]): N
		-- sum of `value' function across all items of `chain'
		do
			Result := sum_meeting (value, create {EL_ANY_QUERY_CONDITION [G]})
		end

	sum_meeting (value: FUNCTION [G, N]; condition: EL_QUERY_CONDITION [G]): N
		-- sum of `value' function across all items of `chain' meeting `condition'
		require
			valid_value_function: container_item.is_valid_for (value)
		do
			if attached {EL_NUMERIC_RESULT [N]} numeric_result as l_sum then
				l_sum.set_to_zero
				do_meeting (agent add_to_sum (l_sum, value, ?), condition)
				Result := l_sum.result_
			end
		end

feature {NONE} -- Implementation

	add_to_sum (a_sum: EL_NUMERIC_RESULT [N]; value: FUNCTION [G, N]; item: G)
		do
			a_sum.add (value (item))
		end

	set_maximum (a_maximum: EL_NUMERIC_RESULT [N]; value: FUNCTION [G, N]; item: G)
		do
			a_maximum.set_max (value (item))
		end

	numeric_result: EL_NUMERIC_RESULT [NUMERIC]
		locaL
			n: N
		do
			Result := Result_table [Eiffel.abstract_type (n)]
		end

feature {NONE} -- Internal attributes

	container: CONTAINER [G]

feature {NONE} -- Constants

	Result_table: SPECIAL [EL_NUMERIC_RESULT [NUMERIC]]
		once
			create Result.make_filled (create {EL_INTEGER_8_RESULT}, natural_64_type + 1)
			Result [Integer_16_type] := create {EL_INTEGER_16_RESULT}
			Result [Integer_32_type] := create {EL_INTEGER_32_RESULT}
			Result [Integer_64_type] := create {EL_INTEGER_64_RESULT}


			Result [Natural_8_type] := create {EL_NATURAL_8_RESULT}
			Result [Natural_16_type] := create {EL_NATURAL_16_RESULT}
			Result [Natural_32_type] := create {EL_NATURAL_32_RESULT}
			Result [Natural_64_type] := create {EL_NATURAL_64_RESULT}

			Result [Real_32_type] := create {EL_REAL_32_RESULT}
			Result [Real_64_type] := create {EL_REAL_64_RESULT}
		end

end