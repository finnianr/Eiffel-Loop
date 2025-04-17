note
	description: "[
		Routines that can be applied to current object if it conforms to ${CONTAINER [G]}.
		Inherits routines from class ${EL_CUMULATIVE_CONTAINER_ARITHMETIC}.
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-17 18:59:01 GMT (Thursday 17th April 2025)"
	revision: "29"

deferred class
	EL_CONTAINER_STRUCTURE [G]

inherit
	EL_CONTAINER_STRUCTURE_BASE [G]
		export
			{EL_CONTAINER_HANDLER} new_special
			{EL_CONTAINER_ARITHMETIC} item_area
		end

	EL_CUMULATIVE_CONTAINER_ARITHMETIC [G]

feature -- Queries

	first: G
		do
			Result := container_first (current_container)
		end

	inverse_query_if (condition: EL_PREDICATE_QUERY_CONDITION [G]): like query
		do
			Result := query (not condition)
		end

	query (condition: EL_QUERY_CONDITION [G]): EL_ARRAYED_LIST [G]
			-- all item meeting condition
		local
			l_count: INTEGER
		do
			l_count := count
			if l_count > 0 then
				create Result.make (l_count)
				do_meeting (create {EL_EXTEND_SPECIAL_ACTION [G]}.make (Result.area), condition)
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
			valid_value_function: valid_open_argument (value)
			result_type_same_as_target: result_type (value) ~ target_value.generating_type
		local
			condition: EL_FUNCTION_VALUE_QUERY_CONDITION [G]
		do
			create condition.make (target_value, value)
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

feature -- Measurement

	count_meeting (condition: EL_QUERY_CONDITION [G]): INTEGER
		-- count of items meeting `condition'
		local
			counter: EL_COUNTING_ACTION [G]
		do
			create counter
			do_meeting (counter, condition)
			Result := counter.count
		end

	count_of (condition: EL_PREDICATE_QUERY_CONDITION [G]): INTEGER
		do
			Result := count_meeting (condition)
		end

feature -- Conversion

	slice: EL_SLICEABLE_SPECIAL [G]
		-- representation of `current_container' as an array that can
		-- be sliced using base zero modulo indexing
		do
			create Result.make (new_special (True, False), count)
		end

	slice_list (start_index, end_index: INTEGER): EL_ARRAYED_LIST [G]
		-- representation of `current_container' as an arrayed list that can
		-- be sliced using base zero modulo indexing
		do
			create Result.make_from_special (slice [start_index, end_index])
		end

	to_array: ARRAY [G]
		do
			create Result.make_from_special (to_special)
		end

	to_special: SPECIAL [G]
		-- special array with same count
		do
			Result := new_special (False, True)
		ensure
			same_count: Result.count = count
		end

	to_special_shared: SPECIAL [G]
		-- special array which is shared if `Current' conforms to ` [G]'
		do
			Result := new_special (True, False)
		end

feature -- Function result list

	derived_list (to_value: FUNCTION [G, ANY]): EL_ARRAYED_LIST [ANY]
		require
			single_open_argument: to_value.open_count = 1
			valid_open_argument: valid_open_argument (to_value)
		local
			i, i_final: INTEGER
		do
			if attached Arrayed_list_factory.new_result_list (to_value, count) as list
				and then attached new_special (True, True) as l_area
			then
				i_final := list.capacity
				from i := 0 until i = i_final loop
					list.extend (to_value (l_area [i]))
					i := i + 1
				end
				Result := list
			else
				create Result.make_empty
			end
		end

	derived_list_if (to_value: FUNCTION [G, ANY]; condition: EL_PREDICATE_QUERY_CONDITION [G]): EL_ARRAYED_LIST [ANY]
		do
			Result := derived_list_meeting (to_value, condition)
		end

	derived_list_meeting (to_value: FUNCTION [G, ANY]; condition: EL_QUERY_CONDITION [G]): EL_ARRAYED_LIST [ANY]
		require
			single_open_argument: to_value.open_count = 1
			valid_open_argument: valid_open_argument (to_value)
		local
			i, i_final: INTEGER
		do
			if attached Arrayed_list_factory.new_result_list (to_value, count) as list
				and then attached new_special (True, True) as l_area
			then
				i_final := list.capacity
				from i := 0 until i = i_final loop
					if attached l_area [i] as item and then condition.met (item) then
						list.extend (to_value (item))
					end
					i := i + 1
				end
				list.trim
				Result := list
			else
				create Result.make_empty
			end
		end

feature -- String result list

	string_32_list (to_string_32: FUNCTION [G, STRING_32]): EL_STRING_32_LIST
			-- list of strings `to_string_32 (item)' for all items in `Current'
		require
			valid_value_function: valid_open_argument (to_string_32)
		do
			if attached {EL_ARRAYED_LIST [STRING_32]} derived_list (to_string_32) as list then
				create Result.make_from_special (list.area)
			else
				create Result.make_empty
			end
		end

	string_8_list (to_string_8: FUNCTION [G, STRING_8]): EL_STRING_8_LIST
			-- list of strings `to_string_8 (item)' for all items in `Current'
		require
			valid_value_function: valid_open_argument (to_string_8)
		do
			if attached {EL_ARRAYED_LIST [STRING_8]} derived_list (to_string_8) as list then
				create Result.make_from_special (list.area)
			else
				create Result.make_empty
			end
		end

	string_list (to_string: FUNCTION [G, ZSTRING]): EL_ZSTRING_LIST
			-- list of strings `to_string (item)' for all items in `Current'
		require
			valid_value_function: valid_open_argument (to_string)
		do
			if attached {EL_ARRAYED_LIST [ZSTRING]} derived_list (to_string) as list then
				create Result.make_from_special (list.area)
			else
				create Result.make_empty
			end
		end

feature -- Basic operations

	do_action_for_all (action: PROCEDURE [G])
		do
			if attached item_area as area then
				area.do_all_in_bounds (action, 0, count - 1)
			else
				do_action_meeting (action, any_item)
			end
		end

	do_action_meeting (action: PROCEDURE [G]; condition: EL_QUERY_CONDITION [G])
		-- list of indices meeting `condition'
		do
			do_meeting (create {EL_CALL_PROCEDURE_ACTION [G]}.make (action), condition)
		end

	do_for_all (action: EL_CONTAINER_ACTION [G])
		local
			i, i_upper: INTEGER
		do
			if attached item_area as area then
			-- use `count' and not `area.count' because container might be a string with a null character
				i_upper := count - 1
				from i := 0 until i > i_upper loop
					action.do_with (area [i])
					i := i + 1
				end
			else
				do_meeting (action, any_item)
			end
		end

	do_meeting (action: EL_CONTAINER_ACTION [G]; condition: EL_QUERY_CONDITION [G])
		-- perform `action' for each item meeting `condition'
		local
			i, upper, i_upper: INTEGER; l_area: SPECIAL [G]
		do
			if attached current_container as container then
				inspect type_of_container (container)
					when Type_special, Type_string then
						if attached item_area as area then
							i_upper := count - 1
							from i := 0 until i > i_upper loop
								action.do_if (area [i], condition)
								i := i + 1
							end
						end
					when Type_linear then
						if attached {LINEAR [G]} container as list then
							push_cursor
							from list.start until list.after loop
								action.do_if (list.item, condition)
								list.forth
							end
							pop_cursor
						end
					when Type_indexable then
						if attached {READABLE_INDEXABLE [G]} container as indexable then
							upper := indexable.upper
							from i := indexable.lower until i > upper loop
								action.do_if (indexable [i], condition)
								i := i + 1
							end
						end
					when Type_iterable then
						if attached {ITERABLE [G]} container as iterable_list then
							across iterable_list as list loop
								action.do_if (list.item, condition)
							end
						end
				else
					if attached container.linear_representation as list then
						from list.start until list.after loop
							action.do_if (list.item, condition)
							list.forth
						end
					end
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

feature {NONE} -- Implementation

	current_structure: EL_CONTAINER_STRUCTURE [G]
		do
			Result := Current
		end

note
	descendants: "[
			EL_CONTAINER_STRUCTURE* [G]
				${EL_CONTAINER_WRAPPER [G]}
				${EL_LINEAR* [G]}
					${EL_CHAIN* [G]}
						${EL_ARRAYED_LIST [G]}
					${EL_FILE_GENERAL_LINE_SOURCE* [S -> STRING_GENERAL create make end]}
				${EL_HASH_TABLE [G, K -> HASHABLE]}
					${EL_GROUPED_LIST_TABLE [G, K -> HASHABLE]}
				${EL_HASH_SET [H -> HASHABLE]}
				${EL_CONTAINER_ARITHMETIC [G, N -> NUMERIC]}
	]"

end