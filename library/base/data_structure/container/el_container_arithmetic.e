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
	date: "2025-04-17 19:06:16 GMT (Thursday 17th April 2025)"
	revision: "24"

class
	EL_CONTAINER_ARITHMETIC [G, N -> NUMERIC]

inherit
	EL_CONTAINER_STRUCTURE [G]
		export
			{NONE} all
			{ANY} valid_open_argument
		redefine
			item_area
		end

	EL_CONTAINER_HANDLER

	REFLECTOR_CONSTANTS
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (structure: EL_CONTAINER_STRUCTURE [G])
		require
			valid_numeric_type: valid_numeric_type
		do
			current_container := structure.current_container
			item_area := structure.item_area
		end

feature -- Access

	max (value: FUNCTION [G, N]): N
		-- maximum of `value' function across all items of `chain'
		do
			Result := max_meeting (value, any_item)
		end

	max_meeting (value: FUNCTION [G, N]; condition: EL_QUERY_CONDITION [G]): N
		-- maximum of `value' function across all items of `chain' meeting `condition'
		require
			valid_value_function: valid_open_argument (value)
		local
			find_maximum: EL_NUMERIC_MAXIMUM_ACTION [G, N]
		do
			if attached {EL_NUMERIC_RESULT [N]} numeric_result as number then
				create find_maximum.make (number, value)
				do_meeting (find_maximum, condition)
				Result := find_maximum.number.value
			end
		end

	min (value: FUNCTION [G, N]): N
		-- minimum of `value' function across all items of `chain'
		do
			Result := min_meeting (value, any_item)
		end

	min_meeting (value: FUNCTION [G, N]; condition: EL_QUERY_CONDITION [G]): N
		-- minimum of `value' function across all items of `chain' meeting `condition'
		require
			valid_value_function: valid_open_argument (value)
		local
			find_minimum: EL_NUMERIC_MINIMUM_ACTION [G, N]
		do
			if attached {EL_NUMERIC_RESULT [N]} numeric_result as number then
				create find_minimum.make (number, value)
				do_meeting (find_minimum, condition)
				Result := find_minimum.number.value
			end
		end

	sum (value: FUNCTION [G, N]): N
		-- sum of `value' function across all items of `chain'
		do
			Result := sum_meeting (value, any_item)
		end

	sum_meeting (value: FUNCTION [G, N]; condition: EL_QUERY_CONDITION [G]): N
		-- sum of `value' function across all items of `chain' meeting `condition'
		require
			valid_value_function: valid_open_argument (value)
		local
			calculate_sum: EL_NUMERIC_SUM_ACTION [G, N]
		do
			if attached {EL_NUMERIC_RESULT [N]} numeric_result as number then
				create calculate_sum.make (number, value)
				do_meeting (calculate_sum, condition)
				Result := calculate_sum.number.value
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

	numeric_result: EL_NUMERIC_RESULT [NUMERIC]
		locaL
			n: N
		do
			Result := Result_table [Eiffel.abstract_type (n)]
		end

feature {NONE} -- Internal attributes

	current_container: CONTAINER [G]

	item_area: detachable SPECIAL [G]

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