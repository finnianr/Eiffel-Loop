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
	date: "2024-09-30 15:27:59 GMT (Monday 30th September 2024)"
	revision: "22"

class
	EL_CONTAINER_ARITHMETIC [G, N -> NUMERIC]

inherit
	EL_CONTAINER_STRUCTURE [G]
		rename
			current_container as container
		export
			{NONE} all
			{ANY} valid_open_argument
		end

	REFLECTOR_CONSTANTS
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (a_container: like container)
		require
			valid_numeric_type: valid_numeric_type
		do
			container := a_container
		end

feature -- Access

	max (value: FUNCTION [G, N]): N
		-- maximum of `value' function across all items of `chain'
		do
			Result := max_meeting (value, create {EL_ANY_QUERY_CONDITION [G]})
		end

	max_meeting (value: FUNCTION [G, N]; condition: EL_QUERY_CONDITION [G]): N
		-- maximum of `value' function across all items of `chain' meeting `condition'
		require
			valid_value_function: valid_open_argument (value)
		do
			if attached {EL_NUMERIC_RESULT [N]} numeric_result as l_max then
				l_max.set_to_min_value
				do_meeting (agent set_max (l_max, value, ?), condition)
				Result := l_max.value
			end
		end

	min (value: FUNCTION [G, N]): N
		-- minimum of `value' function across all items of `chain'
		do
			Result := min_meeting (value, create {EL_ANY_QUERY_CONDITION [G]})
		end

	min_meeting (value: FUNCTION [G, N]; condition: EL_QUERY_CONDITION [G]): N
		-- minimum of `value' function across all items of `chain' meeting `condition'
		require
			valid_value_function: valid_open_argument (value)
		do
			if attached {EL_NUMERIC_RESULT [N]} numeric_result as l_min then
				l_min.set_to_max_value
				do_meeting (agent set_min (l_min, value, ?), condition)
				Result := l_min.value
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
			valid_value_function: valid_open_argument (value)
		do
			if attached {EL_NUMERIC_RESULT [N]} numeric_result as l_sum then
				l_sum.set_to_zero
				do_meeting (agent add_to_sum (l_sum, value, ?), condition)
				Result := l_sum.value
			end
		end

feature -- Contract Support

	valid_numeric_type: BOOLEAN
		local
			n: N; abstract_type: INTEGER
		do
			if ({N}).is_expanded then
				if Result_table.valid_index (abstract_type) then
					abstract_type := Eiffel.abstract_type (n)
					Result := Result_table [abstract_type].value_type ~ {N}
				end
			end
		end

feature {NONE} -- Implementation

	add_to_sum (a_result: EL_NUMERIC_RESULT [N]; value: FUNCTION [G, N]; item: G)
		do
			a_result.add (value (item))
		end

	numeric_result: EL_NUMERIC_RESULT [NUMERIC]
		locaL
			n: N
		do
			Result := Result_table [Eiffel.abstract_type (n)]
		end

	set_max (a_result: EL_NUMERIC_RESULT [N]; value: FUNCTION [G, N]; item: G)
		do
			a_result.set_max (value (item))
		end

	set_min (a_result: EL_NUMERIC_RESULT [N]; value: FUNCTION [G, N]; item: G)
		do
			a_result.set_min (value (item))
		end

feature {NONE} -- Internal attributes

	container: CONTAINER [G]

feature {NONE} -- Constants

	Result_table: SPECIAL [EL_NUMERIC_RESULT [NUMERIC]]
		once
			create Result.make_filled (create {EL_INTEGER_8_RESULT}, Max_predefined_type + 1)
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