note
	description: "[
		Cursor position save/restore routines for containers that conform to [$source CURSOR_STRUCTURE [G]]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-14 18:15:14 GMT (Friday 14th October 2022)"
	revision: "2"

deferred class
	EL_TRAVERSABLE_STRUCTURE [G]

inherit
	ANY

	EL_MODULE_ITERABLE

feature -- Access

	indices_meeting (condition: EL_QUERY_CONDITION [G]): SPECIAL [INTEGER]
		-- list of indices meeting `condition'
		local
			i, upper: INTEGER
		do
			create Result.make_empty (current_count)
			if attached {LINEAR [G]} current_traversable as list then
				push_cursor
				from list.start until list.after loop
					if condition.met (list.item) then
						Result.extend (list.index)
					end
					list.forth
				end
				pop_cursor

			elseif attached {READABLE_INDEXABLE [G]} current_traversable as array then
				upper := array.upper
				from i := array.lower until i > upper loop
					if condition.met (array [i]) then
						Result.extend (i)
					end
					i := i + 1
				end
			elseif attached current_traversable.linear_representation as list then
				from list.start until list.after loop
					if condition.met (list.item) then
						Result.extend (list.index)
					end
					list.forth
				end
			end
		end

	inverse_query_if (condition: EL_PREDICATE_QUERY_CONDITION [G]): like query
		do
			Result := query (not condition)
		end

	query_if (condition: EL_PREDICATE_QUERY_CONDITION [G]): like query
		-- all items meeting agent predicate condition
		do
			Result := query (condition)
		end

	query (condition: EL_QUERY_CONDITION [G]): EL_ARRAYED_LIST [G]
			-- all item meeting condition
		local
			indices: SPECIAL [INTEGER]; i, index: INTEGER
		do
			indices := indices_meeting (condition)
			create Result.make (indices.count)
			if attached {LINEAR [G]} current_traversable as list then
				push_cursor
				list.start
				from i := 0 until i = indices.count loop
					index := indices [i]
					from until list.index = index loop
						list.forth
					end
					Result.extend (list.item)
					i := i + 1
				end
				pop_cursor

			elseif attached {READABLE_INDEXABLE [G]} current_traversable as array then
				from i := 0 until i = indices.count loop
					Result.extend (array [indices [i]])
					i := i + 1
				end

			elseif attached current_traversable.linear_representation as list then
				list.start
				from i := 0 until i = indices.count loop
					index := indices [i]
					from until list.index = index loop
						list.forth
					end
					Result.extend (list.item)
					i := i + 1
				end
			end
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
			if attached current_traversable.linear_representation as list then
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
			if attached {FINITE [G]} current_traversable as finite then
				Result := finite.count

			elseif attached {READABLE_INDEXABLE [G]} current_traversable as array then
				Result :=  array.upper - array.lower + 1

			elseif attached {ITERABLE [G]} current_traversable as current_iterable then
				across current_iterable as list loop
					Result := Result + 1
				end
			end
		end

feature -- Summation

	sum_double (value: FUNCTION [G, DOUBLE]): DOUBLE
			-- sum of call to `value' function
		do
			Result := (create {EL_RESULT_SUMMATOR [G, DOUBLE]}).sum (current_traversable, value)
		end

	sum_double_meeting (value: FUNCTION [G, DOUBLE]; condition: EL_QUERY_CONDITION [G]): DOUBLE
			-- sum of call to `value' function for all items meeting `condition'
		do
			Result := (create {EL_RESULT_SUMMATOR [G, DOUBLE]}).sum_meeting (current_traversable, value, condition)
		end

	sum_integer (value: FUNCTION [G, INTEGER]): INTEGER
			-- sum of call to `value' function
		do
			Result := (create {EL_RESULT_SUMMATOR [G, INTEGER]}).sum (current_traversable, value)
		end

	sum_integer_meeting (value: FUNCTION [G, INTEGER]; condition: EL_QUERY_CONDITION [G]): INTEGER
			-- sum of call to `value' function for all items meeting `condition'
		do
			Result := (create {EL_RESULT_SUMMATOR [G, INTEGER]}).sum_meeting (current_traversable, value, condition)
		end

	sum_natural (value: FUNCTION [G, NATURAL]): NATURAL
			-- sum of call to `value' function
		do
			Result := (create {EL_RESULT_SUMMATOR [G, NATURAL]}).sum (current_traversable, value)
		end

	sum_natural_meeting (value: FUNCTION [G, NATURAL]; condition: EL_QUERY_CONDITION [G]): NATURAL
			-- sum of call to `value' function for all items meeting `condition'
		do
			Result := (create {EL_RESULT_SUMMATOR [G, NATURAL]}).sum_meeting (current_traversable, value, condition)
		end

	sum_real (value: FUNCTION [G, REAL]): REAL
			-- sum of call to `value' function
		do
			Result := (create {EL_RESULT_SUMMATOR [G, REAL]}).sum (current_traversable, value)
		end

	sum_real_meeting (value: FUNCTION [G, REAL]; condition: EL_QUERY_CONDITION [G]): REAL
			-- sum of call to `value' function for all items meeting `condition'
		do
			Result := (create {EL_RESULT_SUMMATOR [G, REAL]}).sum_meeting (current_traversable, value, condition)
		end

feature -- Basic operations

	pop_cursor
		-- restore cursor position from stack
		local
			index: INTEGER
		do
			if attached {CURSOR_STRUCTURE [G]} current_traversable as structure then
				restore_cursor (structure)

			elseif attached {LINEAR [G]} current_traversable as linear then
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
			if attached {CURSOR_STRUCTURE [G]} current_traversable as structure then
				save_cursor (structure)

			elseif attached {LINEAR [G]} current_traversable as linear then
				Index_stack.put (linear.index)
			end
		end

feature -- Contract Support

	container_item: EL_CONTAINER_ITEM [G]
		do
			create Result.make (current_traversable)
		end

	result_type (value: FUNCTION [G, ANY]): TYPE [ANY]

		do
			Result := value.generating_type.generic_parameter_type (2)
		end

feature {NONE} -- Implementation

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

feature {NONE} -- Implementation

	current_traversable: TRAVERSABLE [G]
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