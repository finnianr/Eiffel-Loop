note
	description: "[
		Routines that can be applied to current object if it conforms to [$source CONTAINER [G]]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-16 11:11:00 GMT (Sunday 16th October 2022)"
	revision: "5"

deferred class
	EL_CONTAINER_STRUCTURE [G]

inherit
	ANY

	EL_MODULE_ITERABLE

feature -- Access

	inverse_query_if (condition: EL_PREDICATE_QUERY_CONDITION [G]): like query
		do
			Result := query (not condition)
		end

	query (condition: EL_QUERY_CONDITION [G]): EL_ARRAYED_LIST [G]
			-- all item meeting condition
		local
			area: SPECIAL [G]; l_count: INTEGER
		do
			l_count := current_count
			if l_count > 0 then
				create area.make_empty (l_count)
				do_meeting (agent area.extend, condition)
				if area.count > 5 and then (area.count / l_count) < 0.95 then
					area := area.aliased_resized_area (area.count)
				end
				create Result.make_from_special (area)
			else
				create Result.make_empty
			end
		end

	query_if (condition: EL_PREDICATE_QUERY_CONDITION [G]): like query
		-- all items meeting agent predicate condition
		do
			Result := query (condition)
		end

	query_is_equal (target_value: ANY; value: FUNCTION [G, ANY]): EL_ARRAYED_LIST [G]
		-- list of all items where `value (item).is_equal (target_value)'
		require
			valid_value_function: container_item.is_valid_for (value)
			result_type_same_as_target: result_type (value) ~ target_value.generating_type
		local
			condition: EL_FUNCTION_VALUE_QUERY_CONDITION [G]
		do
			create condition.make (target_value, value)
			Result := query (condition)
		end

feature -- Measurement

	count_meeting (condition: EL_QUERY_CONDITION [G]): INTEGER
		-- count of items meeting `condition'
		do
			if attached current_container.linear_representation as list then
				push_cursor
				from list.start until list.after loop
					if condition.met (list.item) then
						Result := Result + 1
					end
					list.forth
				end
				pop_cursor
			end
		end

	count_of (condition: EL_PREDICATE_QUERY_CONDITION [G]): INTEGER
		do
			Result := count_meeting (condition)
		end

	current_count: INTEGER
		do
			Result := container_count (current_container)
		end

feature -- Summation

	sum_double (value: FUNCTION [G, DOUBLE]): DOUBLE
			-- sum of call to `value' function
		do
			Result := double_summator.sum (value)
		end

	sum_double_meeting (value: FUNCTION [G, DOUBLE]; condition: EL_QUERY_CONDITION [G]): DOUBLE
			-- sum of call to `value' function for all items meeting `condition'
		do
			Result := double_summator.sum_meeting (value, condition)
		end

	sum_integer (value: FUNCTION [G, INTEGER]): INTEGER
			-- sum of call to `value' function
		do
			Result := integer_summator.sum (value)
		end

	sum_integer_meeting (value: FUNCTION [G, INTEGER]; condition: EL_QUERY_CONDITION [G]): INTEGER
			-- sum of call to `value' function for all items meeting `condition'
		do
			Result := integer_summator.sum_meeting (value, condition)
		end

	sum_natural (value: FUNCTION [G, NATURAL]): NATURAL
			-- sum of call to `value' function
		do
			Result := natural_summator.sum (value)
		end

	sum_natural_meeting (value: FUNCTION [G, NATURAL]; condition: EL_QUERY_CONDITION [G]): NATURAL
			-- sum of call to `value' function for all items meeting `condition'
		do
			Result := natural_summator.sum_meeting (value, condition)
		end

	sum_real (value: FUNCTION [G, REAL]): REAL
			-- sum of call to `value' function
		do
			Result := real_summator.sum (value)
		end

	sum_real_meeting (value: FUNCTION [G, REAL]; condition: EL_QUERY_CONDITION [G]): REAL
			-- sum of call to `value' function for all items meeting `condition'
		do
			Result := real_summator.sum_meeting (value, condition)
		end

feature -- Conversion

	to_array: ARRAY [G]
		local
			array: SPECIAL [G]; i, upper: INTEGER
		do
			create array.make_empty (current_count)
			if attached {LINEAR [G]} current_container as list then
				push_cursor
				from list.start until list.after loop
					array.extend (list.item)
					list.forth
				end
				pop_cursor

			elseif attached {READABLE_INDEXABLE [G]} current_container as indexable then
				upper := indexable.upper
				from i := indexable.lower until i > upper loop
					array.extend (indexable [i])
					i := i + 1
				end
			elseif attached current_container.linear_representation as list then
				from list.start until list.after loop
					array.extend (list.item)
					list.forth
				end
			end
			create Result.make_from_special (array)
		end

feature -- String result list

	string_32_list (to_string_32: FUNCTION [G, STRING_32]): EL_STRING_32_LIST
			-- list of strings `to_string_32 (item)' for all items in `Current'
		require
			valid_value_function: container_item.is_valid_for (to_string_32)
		local
			result_list: EL_ARRAYED_RESULT_LIST [G, STRING_32]
		do
			create result_list.make (current_container, to_string_32)
			create Result.make_from_array (result_list.to_array)
		end

	string_8_list (to_string_8: FUNCTION [G, STRING_8]): EL_STRING_8_LIST
			-- list of strings `to_string_8 (item)' for all items in `Current'
		require
			valid_value_function: container_item.is_valid_for (to_string_8)
		local
			result_list: EL_ARRAYED_RESULT_LIST [G, STRING_8]
		do
			create result_list.make (current_container, to_string_8)
			create Result.make_from_array (result_list.to_array)
		end

	string_list (to_string: FUNCTION [G, ZSTRING]): EL_ZSTRING_LIST
			-- list of strings `to_string (item)' for all items in `Current'
		require
			valid_value_function: container_item.is_valid_for (to_string)
		local
			result_list: EL_ARRAYED_RESULT_LIST [G, ZSTRING]
		do
			create result_list.make (current_container, to_string)
			create Result.make_from_array (result_list.to_array)
		end

feature -- Basic operations

	do_for_all (action: PROCEDURE [G])
		do
			do_meeting (action, create {EL_ANY_QUERY_CONDITION [G]})
		end

	do_meeting (action: PROCEDURE [G]; condition: EL_QUERY_CONDITION [G])
		-- list of indices meeting `condition'
		local
			i, upper, i_final: INTEGER
		do
			if attached {ARRAY [G]} current_container as array and then attached array.area as area then
				i_final := array.count
				from i := 0 until i = i_final loop
					if attached area [i] as l_item and then condition.met (l_item) then
						action (l_item)
					end
					i := i + 1
				end

			elseif attached {ARRAYED_LIST [G]} current_container as array and then attached array.area as area then
				i_final := array.count
				from i := 0 until i = i_final loop
					if attached area [i] as l_item and then condition.met (l_item) then
						action (l_item)
					end
					i := i + 1
				end

			elseif attached {LINEAR [G]} current_container as list then
				push_cursor
				from list.start until list.after loop
					if attached list.item as l_item and then condition.met (l_item) then
						action (l_item)
					end
					list.forth
				end
				pop_cursor

			elseif attached {READABLE_INDEXABLE [G]} current_container as array then
				upper := array.upper
				from i := array.lower until i > upper loop
					if attached array [i] as l_item and then condition.met (l_item) then
						action (l_item)
					end
					i := i + 1
				end

			elseif attached {ITERABLE [G]} current_container as iterable_list then
				across iterable_list as list loop
					if attached list.item as l_item and then condition.met (l_item) then
						action (l_item)
					end
				end

			elseif attached current_container.linear_representation as list then
				from list.start until list.after loop
					if attached list.item as l_item and then condition.met (l_item) then
						action (l_item)
					end
					list.forth
				end
			end
		end

	pop_cursor
		-- restore cursor position from stack
		local
			index: INTEGER
		do
			if attached {CURSOR_STRUCTURE [G]} current_container as structure then
				restore_cursor (structure)

			elseif attached {LINEAR [G]} current_container as linear then
				index := Index_stack.item
				Index_stack.remove
				from linear.start until linear.index = index or linear.after loop
					linear.forth
				end
			end
		end

	push_cursor
		-- push cursor position on to stack
		do
			if attached {CURSOR_STRUCTURE [G]} current_container as structure then
				save_cursor (structure)

			elseif attached {LINEAR [G]} current_container as linear then
				Index_stack.put (linear.index)
			end
		end

feature -- Contract Support

	container_item: EL_CONTAINER_ITEM [G]
		do
			create Result.make (current_container)
		end

	result_type (value: FUNCTION [G, ANY]): TYPE [ANY]

		do
			Result := value.generating_type.generic_parameter_type (2)
		end

feature {NONE} -- Implementation

	double_summator: EL_RESULT_SUMMATOR [G, DOUBLE]
		do
			create Result.make (current_container)
		end

	container_count (container: CONTAINER [ANY]): INTEGER
		do
			if attached {FINITE [ANY]} container as finite then
				Result := finite.count

			elseif attached {READABLE_INDEXABLE [ANY]} container as array then
				Result :=  array.upper - array.lower + 1

			elseif attached {BINARY_TREE [ANY]} container as tree then
				Result :=  tree.count

			elseif attached {SEARCH_TABLE [HASHABLE]} container as table then
				Result :=  table.count

			elseif attached {ITERABLE [ANY]} container as current_iterable then
				across current_iterable as list loop
					Result := Result + 1
				end
			end
		end

	integer_summator: EL_RESULT_SUMMATOR [G, INTEGER]
		do
			create Result.make (current_container)
		end

	natural_summator: EL_RESULT_SUMMATOR [G, NATURAL]
		do
			create Result.make (current_container)
		end

	real_summator: EL_RESULT_SUMMATOR [G, REAL]
		do
			create Result.make (current_container)
		end

	restore_cursor (structure: CURSOR_STRUCTURE [G])
		do
			if attached {CHAIN [G]} structure as chain then
				chain.go_i_th (Index_stack.item)
				Index_stack.remove
			else
				structure.go_to (Cursor_stack.item)
				Cursor_stack.remove
			end
		end

	save_cursor (structure: CURSOR_STRUCTURE [G])
		do
			if attached {CHAIN [G]} structure as chain then
				Index_stack.put (chain.index)
			else
				Cursor_stack.put (structure.cursor)
			end
		end

feature {NONE} -- Deferred implementation

	current_container: CONTAINER [G]
		-- assign Current to Result in descendant
		deferred
		end

feature {NONE} -- Constants

	Cursor_stack: ARRAYED_STACK [CURSOR]
		once
			create Result.make (5)
		end

	Index_stack: ARRAYED_STACK [INTEGER]
		once
			create Result.make (5)
		end
end