note
	description: "Sequence of items"
	tests: "Class [$source CHAIN_TEST_SET]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-27 12:55:06 GMT (Monday 27th March 2023)"
	revision: "51"

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
			search, has, occurrences, off
		redefine
			find_first_equal
		end

	EL_INTEGER_MATH
		export
			{NONE} all
		end

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