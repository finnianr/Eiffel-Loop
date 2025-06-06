note
	description: "Sequence of items"
	tests: "Class ${CONTAINER_STRUCTURE_TEST_SET}"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-20 9:13:55 GMT (Sunday 20th April 2025)"
	revision: "64"

deferred class EL_CHAIN [G]

inherit
	CHAIN [G]
		rename
			append as append_sequence
		undefine
			do_all, for_all, index_of, there_exists
		end

	EL_LINEAR [G]
		undefine
			count, first, search, has, occurrences, off
		redefine
			find_first_equal
		end

	EL_INDEXABLE_FROM_1

	EL_INTEGER_MATH_I

	EL_MODULE_ITERABLE

feature -- Access

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
		do
			create Result.make_from (Current)
			Result.order_by (sort_value, in_ascending_order)
			if object_comparison then
				Result.compare_objects
			end
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

feature -- Contract Support

	item_or_void: like item
		do
			if not off then
				Result := item
			end
		end

feature {NONE} -- Implementation

	current_chain: like Current
		do
			Result := Current
		end

note
	descendants: "[
			EL_CHAIN* [G]
				${EL_QUERYABLE_CHAIN* [G]}
					${EL_QUERYABLE_ARRAYED_LIST [G]}
						${AIA_CREDENTIAL_LIST}
							${AIA_STORABLE_CREDENTIAL_LIST}
						${ECD_ARRAYED_LIST [G -> EL_STORABLE create make_default end]}
							${COUNTRY_DATA_TABLE}
							${ECD_STORABLE_ARRAYED_LIST [G -> EL_STORABLE create make_default end]}
				${EL_ARRAYED_LIST [G]}
				${EL_STRING_CHAIN* [S -> STRING_GENERAL create make end]}
					${EL_LINKED_STRING_LIST [S -> STRING_GENERAL create make, make_empty end]}
					${EL_STRING_LIST [S -> STRING_GENERAL create make end]}
	]"

end