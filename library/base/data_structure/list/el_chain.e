note
	description: "Sequence of items"
	tests: "Class [$source CHAIN_TEST_SET]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-22 9:58:45 GMT (Wednesday 22nd June 2022)"
	revision: "46"

deferred class EL_CHAIN [G]

inherit
	CHAIN [G]
		rename
			append as append_sequence
		redefine
			index_of
		end

	EL_LINEAR [G]
		undefine
			search, has, index_of, occurrences, off
		redefine
			find_first_equal
		end

	EL_MODULE_EIFFEL
	EL_MODULE_ITERABLE

	EL_INTEGER_MATH
		export
			{NONE} all
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

	index_of (v: like item; i: INTEGER): INTEGER
			-- Index of `i'-th occurrence of item identical to `v'.
			-- (Reference or object equality,
			-- based on `object_comparison'.)
			-- 0 if none.
		do
			push_cursor
			Result := sequential_index_of (v, i)
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

	joined (list: ITERABLE [G]): like Current
		do
			push_cursor
			finish; forth
			Result := duplicate (0)
			Result.accommodate (count + Iterable.count (list))
			Result.append_sequence (Current)
			Result.append (list)
			pop_cursor
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
			valid_value_function: value.valid_operands ([proto_item])
			result_type_same_as_target: result_type (value) ~ target_value.generating_type
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

feature -- Circular indexing

	circular_i_th (i: INTEGER): like item
		-- `item' at `i_th (modulo (i, count) + 1)' where `i' is a zero based index
		-- `i' maybe negative or > `count'
		require
			not_empty: not is_empty
		do
			Result := i_th (modulo (i, count) + 1)
		ensure
			zero_is_first: i = 0 implies Result = first
			minus_1_is_last: i = i.one.opposite implies Result = last
		end

	circular_move (offset: INTEGER)
		do
			if not is_empty then
				go_circular_i_th (zero_index + offset)
			end
		end

	go_circular_i_th (i: INTEGER)
		-- go to `item' at `i_th (modulo (i, count) + 1)' where `i' is a zero based index
		-- `i' maybe negative or > `count'
		require
			not_empty: not is_empty
		do
			go_i_th (modulo (i, count) + 1)
		ensure
			zero_is_first: i = 0 implies item = first
			minus_1_is_last: i = i.one.opposite implies item = last
		end

	zero_index: INTEGER
		-- zero based index for circular routines
		do
			Result := index - 1
		end

feature -- Conversion

	comma_separated_string: ZSTRING
		local
			buffer: EL_ZSTRING_BUFFER_ROUTINES; value: READABLE_STRING_GENERAL
		do
			push_cursor
			Result := buffer.empty
			from start until after loop
				if not isfirst then
					Result.append_character (',')
					Result.append_character (' ')
				end
				if attached {READABLE_STRING_GENERAL} item as str then
					value := str
				elseif attached {EL_PATH} item as path then
					value := path.to_string
				else
					value := item.out
				end
				Result.append_string_general (value)
				forth
			end
			Result := Result.twin
			pop_cursor
		end

	ordered_by (sort_value: FUNCTION [G, COMPARABLE]; in_ascending_order: BOOLEAN): EL_ARRAYED_LIST [G]
		-- ordered list of elements according to `sort_value' function
		local
			map_list: EL_KEY_SORTABLE_ARRAYED_MAP_LIST [COMPARABLE, G]
		do
			create map_list.make_sorted (Current, sort_value, in_ascending_order)
			Result := map_list.value_list
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

feature -- To numeric map list

	double_map_list (to_key: FUNCTION [G, DOUBLE]): EL_ARRAYED_MAP_LIST [DOUBLE, G]
		require
			valid_open_count: to_key.open_count = 1
			valid_value_function: to_key.valid_operands ([proto_item])
		do
			create Result.make_from_values (Current, to_key)
		end

	integer_map_list (to_key: FUNCTION [G, INTEGER]): EL_ARRAYED_MAP_LIST [INTEGER, G]
		require
			valid_open_count: to_key.open_count = 1
			valid_value_function: to_key.valid_operands ([proto_item])
		do
			create Result.make_from_values (Current, to_key)
		end

	natural_map_list (to_key: FUNCTION [G, NATURAL]): EL_ARRAYED_MAP_LIST [NATURAL, G]
		require
			valid_open_count: to_key.open_count = 1
			valid_value_function: to_key.valid_operands ([proto_item])
		do
			create Result.make_from_values (Current, to_key)
		end

	real_map_list (to_key: FUNCTION [G, REAL]): EL_ARRAYED_MAP_LIST [REAL, G]
		require
			valid_open_count: to_key.open_count = 1
			valid_value_function: to_key.valid_operands ([proto_item])
		do
			create Result.make_from_values (Current, to_key)
		end

feature -- To string list

	string_32_list (value: FUNCTION [G, STRING_32]): EL_STRING_LIST [STRING_32]
			-- list of `value (item)' strings of type STRING_32
		require
			valid_open_count: value.open_count = 1
			valid_value_function: value.valid_operands ([proto_item])
		do
			Result := (create {EL_CHAIN_STRING_LIST_COMPILER [G, STRING_32]}).list (Current, value)
		end

	string_8_list (value: FUNCTION [G, STRING]): EL_STRING_LIST [STRING]
			-- list of `value (item)' strings of type STRING_8
		note
			EIS: "name=Unnamed", "protocol=URI", "src=http://www.yourwebsite.com"
		require
			valid_open_count: value.open_count = 1
			valid_value_function: value.valid_operands ([proto_item])
		do
			Result := (create {EL_CHAIN_STRING_LIST_COMPILER [G, STRING]}).list (Current, value)
		end

	string_list (value: FUNCTION [G, ZSTRING]): EL_STRING_LIST [ZSTRING]
			-- list of `value (item)' strings of type EL_ZSTRING
		require
			valid_open_count: value.open_count = 1
			valid_value_function: value.valid_operands ([proto_item])
		do
			Result := (create {EL_CHAIN_STRING_LIST_COMPILER [G, ZSTRING]}).list (Current, value)
		end

feature -- To string map list

	string_32_map_list (to_key: FUNCTION [G, STRING_32]): EL_ARRAYED_MAP_LIST [STRING_32, G]
		require
			valid_open_count: to_key.open_count = 1
			valid_value_function: to_key.valid_operands ([proto_item])
		do
			create Result.make_from_values (Current, to_key)
		end

	string_8_map_list (to_key: FUNCTION [G, STRING]): EL_ARRAYED_MAP_LIST [STRING, G]
		require
			valid_open_count: to_key.open_count = 1
			valid_value_function: to_key.valid_operands ([proto_item])
		do
			create Result.make_from_values (Current, to_key)
		end

	string_map_list (to_key: FUNCTION [G, ZSTRING]): EL_ARRAYED_MAP_LIST [ZSTRING, G]
		require
			valid_open_count: to_key.open_count = 1
			valid_value_function: to_key.valid_operands ([proto_item])
		do
			create Result.make_from_values (Current, to_key)
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
		do
			accommodate (count + Iterable.count (list))
			across list as any loop
				extend (any.item)
			end
		end

	extended alias "+" (v: like item): like Current
		do
			extend (v)
			Result := Current
		end

	order_by (sort_value: FUNCTION [G, COMPARABLE]; in_ascending_order: BOOLEAN)
		-- sort all elements according to `sort_value' function
		local
			l_item: G; new_index: INTEGER
		do
			if not off then
				l_item := item
			end
			across ordered_by (sort_value, in_ascending_order) as v loop
				put_i_th (v.item, v.cursor_index)
				if v.item = l_item then
					new_index := v.cursor_index
				end
			end
			if new_index > 0 then
				go_i_th (new_index)
			end
		ensure
			same_item: old off or else old item_or_void = item
		end

feature -- Removal

	prune_those (condition: PREDICATE [G])
		do
			from start until after loop
				if condition (item) then
					remove
				else
					forth
				end
			end
		end

	remove_last
		do
			finish; remove
		end

feature -- Cursor movement

	find_first_equal (target_value: ANY; value: FUNCTION [G, ANY])
		require else
			result_type_same_as_target: result_type (value) ~ target_value.generating_type
		do
			Precursor (target_value, value)
		end

feature -- Basic operations

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

feature -- Contract Support

	item_or_void: like item
		do
			if not off then
				Result := item
			end
		end

	proto_item: G
		-- uninitialized item for contract support
		do
			if is_empty then
				if attached {G} Eiffel.new_instance_of (({G}).type_id) as new then
					Result := new
				end
			else
				Result := first
			end
		end

	result_type (value: FUNCTION [G, ANY]): TYPE [ANY]

		do
			Result := value.generating_type.generic_parameter_type (2)
		end

feature {NONE} -- Constants

	Cursor_stack: ARRAYED_STACK [CURSOR]
		once
			create Result.make (5)
		end

note
	descendants: "[
			EL_CHAIN* [G]
				[$source EL_ARRAYED_LIST] [G]
					[$source EL_REFLECTED_FIELD_LIST]
					[$source EL_APPLICATION_LIST]
					[$source EL_TUPLE_TYPE_LIST] [T]
					[$source EL_DEFAULT_COMMAND_OPTION_LIST]
					[$source EL_SEQUENTIAL_INTERVALS]
						[$source EL_OCCURRENCE_INTERVALS] [S -> [$source STRING_GENERAL] create make end]
							[$source EL_SPLIT_STRING_LIST] [S -> [$source STRING_GENERAL] create make, make_empty end]
								[$source EL_SPLIT_ZSTRING_LIST]
								[$source EL_SPLIT_STRING_32_LIST]
								[$source EL_IP_ADDRESS_ROUTINES]
								[$source EL_SPLIT_STRING_8_LIST]
						[$source JSON_INTERVALS_OBJECT] [FIELD_ENUM -> [$source EL_ENUMERATION] [NATURAL_16] create make end]
							[$source EL_IP_ADDRESS_META_DATA]
					[$source EL_SORTABLE_ARRAYED_LIST] [G -> [$source COMPARABLE]]
						[$source EL_FILE_PATH_LIST]
						[$source EL_FILE_MANIFEST_LIST]
						[$source EL_STRING_LIST] [S -> [$source STRING_GENERAL] create make, make_empty end]
							[$source EL_ZSTRING_LIST]
								[$source EL_XHTML_STRING_LIST]
								[$source XML_TAG_LIST]
									[$source XML_PARENT_TAG_LIST]
									[$source XML_VALUE_TAG_PAIR]
							[$source EL_STRING_8_LIST]
								[$source EVOLICITY_VARIABLE_REFERENCE]
									[$source EVOLICITY_FUNCTION_REFERENCE]
								[$source AIA_CANONICAL_REQUEST]
							[$source EL_STRING_32_LIST]
					[$source EL_COMMA_SEPARATED_WORDS_LIST]
					[$source CSV_IMPORTABLE_ARRAYED_LIST] [G -> [$source EL_REFLECTIVELY_SETTABLE] create make_default end]
					[$source EL_QUERYABLE_ARRAYED_LIST] [G]
						[$source ECD_ARRAYED_LIST] [G -> [$source EL_STORABLE] create make_default end]
						[$source AIA_CREDENTIAL_LIST]
							[$source AIA_STORABLE_CREDENTIAL_LIST]
					[$source EL_ARRAYED_MAP_LIST] [K, G]
						[$source EL_STYLED_TEXT_LIST]* [S -> [$source STRING_GENERAL]]
							[$source EL_STYLED_STRING_32_LIST]
							[$source EL_STYLED_STRING_8_LIST]
							[$source EL_STYLED_ZSTRING_LIST]
						[$source EL_DECOMPRESSED_DATA_LIST]
						[$source EL_SORTABLE_ARRAYED_MAP_LIST]* [K, G]
							[$source EL_KEY_SORTABLE_ARRAYED_MAP_LIST] [K -> [$source COMPARABLE], G]
							[$source EL_VALUE_SORTABLE_ARRAYED_MAP_LIST] [K, G -> [$source COMPARABLE]]
					[$source EL_TRANSLATION_ITEMS_LIST]
					[$source EL_XDG_DESKTOP_ENTRY_STEPS]
					[$source EL_ARRAYED_RESULT_LIST] [R, G]
				[$source EL_QUERYABLE_CHAIN]* [G]
					[$source EL_QUERYABLE_ARRAYED_LIST] [G]
				[$source EL_STRING_CHAIN]* [S -> [$source STRING_GENERAL] create make, make_empty end]
					[$source EL_LINKED_STRING_LIST] [S -> [$source STRING_GENERAL] create make, make_empty end]
					[$source EL_STRING_LIST] [S -> [$source STRING_GENERAL] create make, make_empty end]
	]"

end



