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
	date: "2024-09-21 18:11:59 GMT (Saturday 21st September 2024)"
	revision: "21"

deferred class
	EL_CONTAINER_STRUCTURE [G]

inherit
	EL_CUMULATIVE_CONTAINER_ARITHMETIC [G]

	EL_MODULE_ITERABLE

	EL_SHARED_FACTORIES

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
			counter: EL_NATURAL_32_COUNTER
		do
			create counter
			do_meeting (agent bump_counter (?, counter), condition)
			Result := counter.item.as_integer_32
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
		do
			Result := new_special (False)
		end

feature -- Function result list

	derived_list (to_value: FUNCTION [G, ANY]): EL_ARRAYED_LIST [ANY]
		require
			single_open_argument: to_value.open_count = 1
			valid_open_argument: valid_open_argument (to_value)
		local
			i, i_final: INTEGER
		do
			if attached Arrayed_list_factory.new_result_list (to_value, current_count) as list
				and then attached new_special (True) as l_area
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
			if attached Arrayed_list_factory.new_result_list (to_value, current_count) as list
				and then attached new_special (True) as l_area
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
			valid_value_function: container_item.is_valid_for (to_string_32)
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
			valid_value_function: container_item.is_valid_for (to_string_8)
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
			valid_value_function: container_item.is_valid_for (to_string)
		do
			if attached {EL_ARRAYED_LIST [ZSTRING]} derived_list (to_string) as list then
				create Result.make_from_special (list.area)
			else
				create Result.make_empty
			end
		end

feature -- Basic operations

	do_for_all (action: PROCEDURE [G])
		require
			not_immutable_string: not is_immutable_string
		do
			if attached {TO_SPECIAL [G]} current_container as special
				and then attached {FINITE [G]} special as finite
			then
				special.area.do_all_in_bounds (action, 0, finite.count - 1)
			else
				do_meeting (action, create {EL_ANY_QUERY_CONDITION [G]})
			end
		end

	do_meeting (action: PROCEDURE [G]; condition: EL_QUERY_CONDITION [G])
		-- list of indices meeting `condition'
		require
			not_immutable_string: not is_immutable_string
		local
			i, upper, i_final: INTEGER
		do
			if attached {TO_SPECIAL [G]} current_container as special
				and then attached {FINITE [G]} special as finite
				and then attached special.area as area
			then
				i_final := finite.count
				from i := 0 until i = i_final loop
					do_if_met (area [i], action, condition)
					i := i + 1
				end

			elseif attached {LINEAR [G]} current_container as list then
				push_cursor
				from list.start until list.after loop
					do_if_met (list.item, action, condition)
					list.forth
				end
				pop_cursor

			elseif attached {READABLE_INDEXABLE [G]} current_container as indexable then
				upper := indexable.upper
				from i := indexable.lower until i > upper loop
					do_if_met (indexable [i], action, condition)
					i := i + 1
				end

			elseif attached {ITERABLE [G]} current_container as iterable_list then
				across iterable_list as list loop
					do_if_met (list.item, action, condition)
				end

			elseif attached current_container.linear_representation as list then
				from list.start until list.after loop
					do_if_met (list.item, action, condition)
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

feature -- Contract Support

	container_item: EL_CONTAINER_ITEM [G]
		do
			create Result.make (current_container)
		end

	is_immutable_string: BOOLEAN
		do
			Result := attached {IMMUTABLE_STRING_GENERAL} current_container
		end

	object_comparison: BOOLEAN
		do
			Result := current_container.object_comparison
		end

	result_type (value: FUNCTION [G, ANY]): TYPE [ANY]

		do
			Result := value.generating_type.generic_parameter_type (2)
		end

	valid_open_argument (to_value: FUNCTION [G, ANY]): BOOLEAN
		-- `True' if `to_value' has single open argument that is the same as `{G}'
		do
			if attached to_value.generating_type.generic_parameter_type (1) as argument_types
				and then argument_types.generic_parameter_count = 1
			then
				Result := argument_types.generic_parameter_type (1) ~ {G}
			end
		end

feature {EL_CONTAINER_HANDLER} -- Implementation

	new_special (shared: BOOLEAN): SPECIAL [G]
		local
			one_extra: INTEGER
		do
			if attached {TO_SPECIAL [G]} current_container as special
				and then attached {FINITE [G]} special as finite
				and then attached special.area as area
			then
				if shared then
					Result := area
				else
				--	one extra for string null terminator
					one_extra := (attached {STRING_GENERAL} special).to_integer
					Result := area.resized_area (finite.count + one_extra)
				end
			else
				create Result.make_empty (current_count)
				do_for_all (agent extend_special (?, Result))
			end
		end

feature {NONE} -- Implementation

	as_structure (container: CONTAINER [G]): EL_CONTAINER_STRUCTURE [G]
		do
			if attached {EL_CONTAINER_STRUCTURE [G]} container as structure then
				Result := structure
			else
				create {EL_CONTAINER_WRAPPER [G]} Result.make (container)
			end
		end

	bump_counter (item: G; counter: EL_NATURAL_32_COUNTER)
		do
			counter.bump
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

	do_if_met (item: G; action: PROCEDURE [G]; condition: EL_QUERY_CONDITION [G])
		do
			if condition.met (item) then
				action (item)
			end
		end

	extend_special (item: G; area: SPECIAL [G])
		do
			area.extend (item)
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

note
	descendants: "[
			EL_CONTAINER_STRUCTURE* [G]
				${EL_CONTAINER_WRAPPER [G]}
				${EL_RESULT_SUMMATOR [G, N -> NUMERIC]}
				${EL_CONTAINER_ITEM [G]}
				${EL_RESULT_MAXIMUM [G, N -> (NUMERIC, COMPARABLE)]}
				${EL_LINEAR* [G]}
					${EL_FILE_GENERAL_LINE_SOURCE* [S -> STRING_GENERAL create make end]}
						${EL_STRING_8_IO_MEDIUM_LINE_SOURCE}
						${EL_PLAIN_TEXT_LINE_SOURCE}
							${EL_ENCRYPTED_PLAIN_TEXT_LINE_SOURCE}
						${EL_ZSTRING_IO_MEDIUM_LINE_SOURCE}
					${EL_CHAIN* [G]}
						${EL_QUERYABLE_CHAIN* [G]}
							${EL_QUERYABLE_ARRAYED_LIST [G]}
						${EL_STRING_CHAIN* [S -> STRING_GENERAL create make end]}
							${EL_LINKED_STRING_LIST [S -> STRING_GENERAL create make, make_empty end]}
							${EL_STRING_LIST [S -> STRING_GENERAL create make end]}
								${EL_TEMPLATE_LIST* [S -> STRING_GENERAL create make end, KEY -> READABLE_STRING_GENERAL]}
						${EL_ARRAYED_LIST [G]}
							${EL_SORTABLE_ARRAYED_LIST [G -> COMPARABLE]}
							${EL_ARRAYED_INTERVAL_LIST}
							${EL_QUERYABLE_ARRAYED_LIST [G]}
							${EL_ARRAYED_REPRESENTATION_LIST* [R, N]}
								${DATE_LIST}
					${EL_LINEAR_STRINGS* [S -> STRING_GENERAL create make end]}
						${EL_SPLIT_STRING_LIST [S -> STRING_GENERAL create make end]}
						${EL_STRING_CHAIN* [S -> STRING_GENERAL create make end]}
				${EL_HASH_SET [H -> HASHABLE]}
	]"

end