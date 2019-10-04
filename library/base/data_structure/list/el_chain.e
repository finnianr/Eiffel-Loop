note
	description: "Sequence of items"
	tests: "Class [$source CHAIN_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-04 13:16:04 GMT (Friday   4th   October   2019)"
	revision: "17"

deferred class EL_CHAIN [G]

inherit
	CHAIN [G]
		rename
			append as append_sequence
		end

	EL_LINEAR [G]
		undefine
			search, has, index_of, occurrences, off
		redefine
			find_first_equal
		end

feature -- Access

	count_meeting (condition: EL_QUERY_CONDITION [G]): INTEGER
		-- count of items meeting `condition'
		do
			push_cursor
			from start until after loop
				if condition.met (item) then
					Result := Result + 1
				end
				forth
			end
			pop_cursor
		end

	count_of (condition: EL_PREDICATE_QUERY_CONDITION [G]): INTEGER
		do
			Result := count_meeting (condition)
		end

	index_for_value (target_value: ANY; value: FUNCTION [G, ANY]): INTEGER
			-- index of item with function returning result equal to value, 0 if not found
		do
			push_cursor
			find_first_equal (target_value, value)
			if found then
				Result := index
			end
			pop_cursor
		end

	indices_meeting (condition: EL_QUERY_CONDITION [G]): SPECIAL [INTEGER]
		-- list of indices meeting `condition'
		local
			i, l_count: INTEGER
		do
			create Result.make_empty (count)
			if attached {EL_ANY_QUERY_CONDITION [G]} condition then
				l_count := count
				from i := 1 until i > l_count loop
					Result.extend (i)
					i := i + 1
				end
			else
				push_cursor
				from start until after loop
					if condition.met (item) then
						Result.extend (index)
					end
					forth
				end
				pop_cursor
			end
		end

feature -- Item query

	inverse_query_if (condition: EL_PREDICATE_QUERY_CONDITION [G]): like query
		do
			Result := query (not condition)
		end

	query (condition: EL_QUERY_CONDITION [G]): EL_ARRAYED_LIST [G]
			-- all item meeting condition
		local
			indices: like indices_meeting; i: INTEGER
		do
			indices := indices_meeting (condition)
			create Result.make (indices.count)
			from i := 0 until i = indices.count loop
				Result.extend (i_th (indices [i]))
				i := i + 1
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
			valid_open_count: value.open_count = 1
			valid_value_function: not is_empty implies value.valid_operands ([first])
			compatible_types: not is_empty implies value (first).same_type (target_value)
		local
			condition: EL_FUNCTION_VALUE_QUERY_CONDITION [G]
		do
			create condition.make (target_value, value)
			Result := query (condition)
		end

	subchain (index_from, index_to: INTEGER ): EL_ARRAYED_LIST [G]
		require
			valid_indices: (1 <= index_from) and (index_from <= index_to) and (index_to <= count)
		local
			i: INTEGER
		do
			push_cursor
			create Result.make (index_to - index_from + 1)
			go_i_th (index_from)
			from i := index_from until i > index_to loop
				Result.extend (item)
				forth
				i := i + 1
			end
			pop_cursor
		end

feature -- Conversion

	double_map_list (to_key: FUNCTION [G, DOUBLE]): EL_ARRAYED_MAP_LIST [DOUBLE, G]
		require
			valid_open_count: to_key.open_count = 1
			valid_value_function: not is_empty implies to_key.valid_operands ([first])
		do
			create Result.make_from_values (Current, to_key)
		end

	integer_map_list (to_key: FUNCTION [G, INTEGER]): EL_ARRAYED_MAP_LIST [INTEGER, G]
		require
			valid_open_count: to_key.open_count = 1
			valid_value_function: not is_empty implies to_key.valid_operands ([first])
		do
			create Result.make_from_values (Current, to_key)
		end

	natural_map_list (to_key: FUNCTION [G, NATURAL]): EL_ARRAYED_MAP_LIST [NATURAL, G]
		require
			valid_open_count: to_key.open_count = 1
			valid_value_function: not is_empty implies to_key.valid_operands ([first])
		do
			create Result.make_from_values (Current, to_key)
		end

	real_map_list (to_key: FUNCTION [G, REAL]): EL_ARRAYED_MAP_LIST [REAL, G]
		require
			valid_open_count: to_key.open_count = 1
			valid_value_function: not is_empty implies to_key.valid_operands ([first])
		do
			create Result.make_from_values (Current, to_key)
		end

	string_32_list (value: FUNCTION [G, STRING_32]): EL_STRING_LIST [STRING_32]
			-- list of `value (item)' strings of type STRING_32
		require
			valid_open_count: value.open_count = 1
			valid_value_function: not is_empty implies value.valid_operands ([first])
		do
			Result := (create {EL_CHAIN_STRING_LIST_COMPILER [G, STRING_32]}).list (Current, value)
		end

	string_32_map_list (to_key: FUNCTION [G, STRING_32]): EL_ARRAYED_MAP_LIST [STRING_32, G]
		require
			valid_open_count: to_key.open_count = 1
			valid_value_function: not is_empty implies to_key.valid_operands ([first])
		do
			create Result.make_from_values (Current, to_key)
		end

	string_8_list (value: FUNCTION [G, STRING]): EL_STRING_LIST [STRING]
			-- list of `value (item)' strings of type STRING_8
		require
			valid_open_count: value.open_count = 1
			valid_value_function: not is_empty implies value.valid_operands ([first])
		do
			Result := (create {EL_CHAIN_STRING_LIST_COMPILER [G, STRING]}).list (Current, value)
		end

	string_8_map_list (to_key: FUNCTION [G, STRING]): EL_ARRAYED_MAP_LIST [STRING, G]
		require
			valid_open_count: to_key.open_count = 1
			valid_value_function: not is_empty implies to_key.valid_operands ([first])
		do
			create Result.make_from_values (Current, to_key)
		end

	string_list (value: FUNCTION [G, ZSTRING]): EL_STRING_LIST [ZSTRING]
			-- list of `value (item)' strings of type EL_ZSTRING
		require
			valid_open_count: value.open_count = 1
			valid_value_function: not is_empty implies value.valid_operands ([first])
		do
			Result := (create {EL_CHAIN_STRING_LIST_COMPILER [G, ZSTRING]}).list (Current, value)
		end

	string_map_list (to_key: FUNCTION [G, ZSTRING]): EL_ARRAYED_MAP_LIST [ZSTRING, G]
		require
			valid_open_count: to_key.open_count = 1
			valid_value_function: not is_empty implies to_key.valid_operands ([first])
		do
			create Result.make_from_values (Current, to_key)
		end

	to_array: ARRAY [G]
		do
			if is_empty then
				create Result.make_empty
			else
				create Result.make_filled (first, 1, count)
				push_cursor
				from start until after loop
					Result [index] := item
					forth
				end
				pop_cursor
			end
		end

feature -- Summation

	sum_double (value: FUNCTION [G, DOUBLE]): DOUBLE
			-- sum of call to `value' function
		do
			Result := (create {EL_CHAIN_SUMMATOR [G, DOUBLE]}).sum (Current, value)
		end

	sum_double_meeting (value: FUNCTION [G, DOUBLE]; condition: EL_QUERY_CONDITION [G]): DOUBLE
			-- sum of call to `value' function for all items meeting `condition'
		do
			Result := (create {EL_CHAIN_SUMMATOR [G, DOUBLE]}).sum_meeting (Current, value, condition)
		end

	sum_integer (value: FUNCTION [G, INTEGER]): INTEGER
			-- sum of call to `value' function
		do
			Result := (create {EL_CHAIN_SUMMATOR [G, INTEGER]}).sum (Current, value)
		end

	sum_integer_meeting (value: FUNCTION [G, INTEGER]; condition: EL_QUERY_CONDITION [G]): INTEGER
			-- sum of call to `value' function for all items meeting `condition'
		do
			Result := (create {EL_CHAIN_SUMMATOR [G, INTEGER]}).sum_meeting (Current, value, condition)
		end

	sum_natural (value: FUNCTION [G, NATURAL]): NATURAL
			-- sum of call to `value' function
		do
			Result := (create {EL_CHAIN_SUMMATOR [G, NATURAL]}).sum (Current, value)
		end

	sum_natural_meeting (value: FUNCTION [G, NATURAL]; condition: EL_QUERY_CONDITION [G]): NATURAL
			-- sum of call to `value' function for all items meeting `condition'
		do
			Result := (create {EL_CHAIN_SUMMATOR [G, NATURAL]}).sum_meeting (Current, value, condition)
		end

	sum_real (value: FUNCTION [G, REAL]): REAL
			-- sum of call to `value' function
		do
			Result := (create {EL_CHAIN_SUMMATOR [G, REAL]}).sum (Current, value)
		end

	sum_real_meeting (value: FUNCTION [G, REAL]; condition: EL_QUERY_CONDITION [G]): REAL
			-- sum of call to `value' function for all items meeting `condition'
		do
			Result := (create {EL_CHAIN_SUMMATOR [G, REAL]}).sum_meeting (Current, value, condition)
		end

feature -- Element change

	accommodate (new_count: INTEGER)
		deferred
		end

	append (list: ITERABLE [G])
		require
			finite: attached {FINITE [G]} list
		do
			if attached {FINITE [G]} list as finite then
				accommodate (count + finite.count)
				across list as it loop
					extend (it.item)
				end
			end
		end

	extended alias "+" (v: like item): like Current
		do
			extend (v)
			Result := Current
		end

feature -- Removal

	remove_last
		do
			finish; remove
		end

feature -- Cursor movement

	find_first_equal (target_value: ANY; value: FUNCTION [G, ANY])
		require else
			compatible_types: not is_empty implies target_value.same_type (value (first))
		do
			Precursor (target_value, value)
		end

	pop_cursor
		-- restore cursor position from stack
		do
			go_to (Cursor_stack.item)
			Cursor_stack.remove
		end

	push_cursor
		-- push cursor position on to stack
		do
			Cursor_stack.put (cursor)
		end

feature {NONE} -- Constants

	Cursor_stack: ARRAYED_STACK [CURSOR]
		once
			create Result.make (5)
		end
end
