note
	description: "[
		Routines that can be applied to current object if it conforms to ${CONTAINER [G]}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-21 9:43:41 GMT (Friday 21st July 2023)"
	revision: "12"

deferred class
	EL_CONTAINER_STRUCTURE [G]

inherit
	EL_CONTAINER_NUMERIC_CALCULATER [G]

	EL_MODULE_ITERABLE

feature -- Access

	item_type: TYPE [G]
		do
			Result := {G}
		end

feature -- Queries

	inverse_query_if (condition: EL_PREDICATE_QUERY_CONDITION [G]): like query
		do
			Result := query (not condition)
		end

	query (condition: EL_QUERY_CONDITION [G]): EL_ARRAYED_LIST [G]
			-- all item meeting condition
		local
			l_count: INTEGER
		do
			l_count := current_count
			if l_count > 0 then
				create Result.make (l_count)
				if attached Result.area as area then
					do_meeting (agent area.extend, condition)
				end
				if Result.count > 5 and then (Result.count / l_count) < 0.95 then
					Result.trim
				end
			else
				create Result.make_empty
			end
		end

	query_if (condition: EL_PREDICATE_QUERY_CONDITION [G]): like query
		-- all items meeting agent predicate condition
		do
			Result := query (condition)
		end

	query_not_in (other: CONTAINER [G]): like query
		-- all items in `Current' not in `other'
		require
			same_comparison: object_comparison = other.object_comparison
		local
			other_has_item: EL_CONTAINER_HAS_QUERY_CONDITION [G]
		do
			create other_has_item.make (other)
			Result := query (not other_has_item)
		end

	query_in, intersection (other: CONTAINER [G]): like query
		-- all items in `Current' that are also in `other'
		require
			same_comparison: object_comparison = other.object_comparison
		local
			other_has_item: EL_CONTAINER_HAS_QUERY_CONDITION [G]
		do
			create other_has_item.make (other)
			Result := query (other_has_item)
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

feature -- Conversion

	to_array: ARRAY [G]
		do
			create Result.make_from_special (to_special)
		end

	to_special: SPECIAL [G]
		local
			i, upper: INTEGER
		do
			create Result.make_empty (current_count)
			if attached {LINEAR [G]} current_container as list then
				push_cursor
				from list.start until list.after loop
					Result.extend (list.item)
					list.forth
				end
				pop_cursor

			elseif attached {READABLE_INDEXABLE [G]} current_container as indexable then
				upper := indexable.upper
				from i := indexable.lower until i > upper loop
					Result.extend (indexable [i])
					i := i + 1
				end
			elseif attached current_container.linear_representation as list then
				from list.start until list.after loop
					Result.extend (list.item)
					list.forth
				end
			end
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
		do
--			Try LINEAR first because `push_cursor' tried it first
			if attached {LINEAR [G]} current_container as linear then
				restore_index (Index_stack.item, linear)
				Index_stack.remove

			elseif attached {CURSOR_STRUCTURE [G]} current_container as structure then
				structure.go_to (Cursor_stack.item)
				Cursor_stack.remove
			end
		end

	restore_index (original_index: INTEGER; linear: LINEAR [G])
		do
			if attached {CHAIN [G]} linear as chain then
				chain.move (original_index - chain.index)

			elseif original_index > 0 then
--				cannot go backwards with LINEAR
				from linear.start until linear.index = original_index or linear.after loop
					linear.forth
				end
			end
		end

	push_cursor
		-- push cursor position on to stack
		do
--			Try LINEAR first because it doesn't create an object
			if attached {LINEAR [G]} current_container as linear then
				Index_stack.put (linear.index)

			elseif attached {CURSOR_STRUCTURE [G]} current_container as structure then
				Cursor_stack.put (structure.cursor)
			end
		end

feature -- Contract Support

	container_item: EL_CONTAINER_ITEM [G]
		do
			create Result.make (current_container)
		end

	object_comparison: BOOLEAN
		do
			Result := current_container.object_comparison
		end

	result_type (value: FUNCTION [G, ANY]): TYPE [ANY]

		do
			Result := value.generating_type.generic_parameter_type (2)
		end

feature {NONE} -- Implementation

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