note
	description: "Sequence of items"
	tests: "Class ${CONTAINER_STRUCTURE_TEST_SET}"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-01 12:55:40 GMT (Monday 1st April 2024)"
	revision: "56"

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
				${EL_QUERYABLE_CHAIN* [G]}
					${EL_QUERYABLE_ARRAYED_LIST [G]}
						${AIA_CREDENTIAL_LIST}
							${AIA_STORABLE_CREDENTIAL_LIST}
						${ECD_ARRAYED_LIST [G -> EL_STORABLE create make_default end]}
							${COUNTRY_DATA_TABLE}
							${ECD_STORABLE_ARRAYED_LIST [G -> EL_STORABLE create make_default end]}
				${EL_ARRAYED_LIST [G]}
					${EL_NAMEABLES_LIST [G -> EL_NAMEABLE [READABLE_STRING_GENERAL]]}
					${EL_UNIQUE_ARRAYED_LIST [G -> HASHABLE]}
					${EL_ARRAYED_COMPACT_INTERVAL_LIST}
					${EL_CALL_SEQUENCE [CALL_ARGS -> TUPLE create default_create end]}
					${EL_DISCARDING_ARRAYED_LIST [G]}
					${EL_DIRECTORY_LIST}
					${EL_ARRAYED_MAP_LIST [K, G]}
						${EL_KEY_INDEXED_ARRAYED_MAP_LIST [K -> COMPARABLE, G]}
						${EL_CONFORMING_INSTANCE_TYPE_MAP [G]}
						${EL_HASHABLE_KEY_ARRAYED_MAP_LIST [K -> HASHABLE, G]}
						${EL_STYLED_TEXT_LIST* [S -> STRING_GENERAL]}
							${EL_STYLED_STRING_8_LIST}
							${EL_STYLED_STRING_32_LIST}
							${EL_STYLED_ZSTRING_LIST}
						${EL_APPLICATION_HELP_LIST}
						${EL_DECOMPRESSED_DATA_LIST}
						${EL_STRING_POOL [S -> STRING_GENERAL create make end]}
						${EL_BOOK_ASSEMBLY}
					${EL_SORTABLE_ARRAYED_LIST [G -> COMPARABLE]}
						${EL_FILE_PATH_LIST}
						${EL_DIRECTORY_PATH_LIST}
							${EL_NATIVE_DIRECTORY_PATH_LIST}
						${EL_FILE_MANIFEST_LIST}
						${EL_IMMUTABLE_STRING_8_LIST}
							${EL_IMMUTABLE_UTF_8_LIST}
						${EL_STRING_LIST [S -> STRING_GENERAL create make end]}
							${EL_STRING_8_LIST}
								${EVOLICITY_VARIABLE_REFERENCE}
									${EVOLICITY_FUNCTION_REFERENCE}
								${AIA_CANONICAL_REQUEST}
							${EL_STRING_32_LIST}
							${EL_ZSTRING_LIST}
								${EL_XHTML_STRING_LIST}
								${XML_TAG_LIST}
									${XML_PARENT_TAG_LIST}
									${XML_VALUE_TAG_PAIR}
								${TB_HTML_LINES}
								${EL_ERROR_DESCRIPTION}
									${EL_COMMAND_ARGUMENT_ERROR}
							${EL_TEMPLATE_LIST* [S -> STRING_GENERAL create make end, KEY -> READABLE_STRING_GENERAL]}
								${EL_SUBSTITUTION_TEMPLATE [S -> STRING_GENERAL create make, make_empty end]}
									${EL_STRING_8_TEMPLATE}
									${EL_STRING_32_TEMPLATE}
									${EL_ZSTRING_TEMPLATE}
								${EL_TEMPLATE [S -> STRING_GENERAL create make, make_empty end]}
									${EL_DATE_TEXT_TEMPLATE}
					${EL_COMMA_SEPARATED_WORDS_LIST}
					${CSV_IMPORTABLE_ARRAYED_LIST [G -> EL_REFLECTIVELY_SETTABLE create make_default end]}
					${EL_NETWORK_DEVICE_LIST_I*}
						${EL_NETWORK_DEVICE_LIST_IMP}
					${EL_ARRAYED_RESULT_LIST [G, R]}
					${EL_SPLIT_READABLE_STRING_LIST [S -> READABLE_STRING_GENERAL create make end]}
						${EL_SPLIT_STRING_LIST [S -> STRING_GENERAL create make end]}
							${EL_SPLIT_STRING_8_LIST}
							${EL_SPLIT_STRING_32_LIST}
							${EL_SPLIT_ZSTRING_LIST}
						${EL_COMPACT_ZSTRING_LIST}
						${EL_IMMUTABLE_STRING_GRID* [GENERAL -> STRING_GENERAL, IMMUTABLE -> IMMUTABLE_STRING_GENERAL create make end]}
							${EL_IMMUTABLE_STRING_8_GRID}
							${EL_IMMUTABLE_STRING_32_GRID}
						${EL_SPLIT_IMMUTABLE_STRING_LIST* [GENERAL -> STRING_GENERAL, IMMUTABLE -> IMMUTABLE_STRING_GENERAL create make end]}
							${EL_SPLIT_IMMUTABLE_STRING_8_LIST}
								${EL_SPLIT_IMMUTABLE_UTF_8_LIST}
							${EL_SPLIT_IMMUTABLE_STRING_32_LIST}
					${EL_TRANSLATION_ITEMS_LIST}
					${TB_EMAIL_LIST}
					${EL_ARRAYED_INTERVAL_LIST}
						${EL_SEQUENTIAL_INTERVALS}
							${JSON_INTERVALS_OBJECT [FIELD_ENUM -> EL_ENUMERATION_NATURAL_16 create make end]}
								${EL_IP_ADDRESS_META_DATA}
							${EL_ZSTRING_INTERVALS}
								${EL_COMPARABLE_ZSTRING_INTERVALS* [C, S -> READABLE_INDEXABLE [C]]}
									${EL_COMPARE_ZSTRING_TO_STRING_8}
										${EL_CASELESS_COMPARE_ZSTRING_TO_STRING_8}
									${EL_COMPARE_ZSTRING_TO_STRING_32}
										${EL_CASELESS_COMPARE_ZSTRING_TO_STRING_32}
							${EL_OCCURRENCE_INTERVALS}
								${EL_SPLIT_INTERVALS}
									${EL_ZSTRING_SPLIT_INTERVALS}
									${EL_STRING_8_SPLIT_INTERVALS}
									${EL_STRING_32_SPLIT_INTERVALS}
								${EL_ZSTRING_OCCURRENCE_INTERVALS}
									${EL_ZSTRING_SPLIT_INTERVALS}
									${EL_ZSTRING_OCCURRENCE_EDITOR}
								${JSON_PARSED_INTERVALS}
									${JSON_NAME_VALUE_LIST}
										${JSON_ZNAME_VALUE_LIST}
								${EL_STRING_8_OCCURRENCE_INTERVALS}
									${EL_STRING_8_SPLIT_INTERVALS}
									${EL_STRING_8_OCCURRENCE_EDITOR}
								${EL_STRING_32_OCCURRENCE_INTERVALS}
									${EL_STRING_32_SPLIT_INTERVALS}
									${EL_STRING_32_OCCURRENCE_EDITOR}
						${TP_REPEATED_PATTERN*}
							${TP_COUNT_WITHIN_BOUNDS}
								${TP_ONE_OR_MORE_TIMES}
								${TP_ZERO_OR_MORE_TIMES}
							${TP_LOOP*}
								${TP_P1_UNTIL_P2_MATCH}
								${TP_P2_WHILE_NOT_P1_MATCH}
					${TP_ALL_IN_LIST}
						${TP_FIRST_MATCH_IN_LIST}
					${JOBS_RESULT_SET}
					${EL_FIELD_LIST}
					${EL_ARRAYED_REPRESENTATION_LIST* [R, N]}
						${DATE_LIST}
					${EL_REFLECTED_REFERENCE_LIST}
					${EL_QUERYABLE_ARRAYED_LIST [G]}
					${EL_PATH_STEP_TABLE}
					${EL_HTTP_PARAMETER_LIST}
					${EL_EVENT_LISTENER_LIST}
						${EL_EVENT_BROADCASTER}
					${EL_XDG_DESKTOP_ENTRY_STEPS}
					${EL_OPF_MANIFEST_LIST}
					${EL_APPLICATION_LIST}
					${EL_TUPLE_TYPE_LIST [T]}
				${EL_STRING_CHAIN* [S -> STRING_GENERAL create make end]}
					${EL_LINKED_STRING_LIST [S -> STRING_GENERAL create make, make_empty end]}
					${EL_STRING_LIST [S -> STRING_GENERAL create make end]}
	]"

end