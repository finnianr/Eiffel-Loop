note
	description: "Extended version of base class ${HASH_TABLE}"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-30 15:19:17 GMT (Monday 30th September 2024)"
	revision: "34"

class
	EL_HASH_TABLE [G, K -> HASHABLE]

inherit
	HASH_TABLE [G, K]
		export
			{HASH_TABLE_ITERATION_CURSOR} deleted_marks
		redefine
			current_keys, default_create, linear_representation, merge, new_cursor
		end

	EL_CONTAINER_STRUCTURE [G]
		undefine
			copy, default_create, is_equal, object_comparison
		end

	EL_CONTAINER_CONVERSION [K]
		rename
			as_structure as as_key_structure
		undefine
			copy, default_create, is_equal
		end

	EL_MODULE_EIFFEL

	EL_SHARED_IMMUTABLE_32_MANAGER; EL_SHARED_IMMUTABLE_8_MANAGER

create
	 default_create, make, make_equal, make_assignments, make_from_map_list, make_from_keys,
	 make_from_manifest_32, make_from_manifest_8, make_one

convert
	make_assignments ({ARRAY [TUPLE [K, G]]})

feature {NONE} -- Initialization

	default_create
		do
			make_equal (Minimum_capacity)
		end

	make_assignments (array: like MANIFEST_ARRAY)
			--
		do
			make_equal (array.count)
			append_tuples (array)
		end

	make_from_manifest_32 (
		to_key: FUNCTION [IMMUTABLE_STRING_32, K]; to_item: FUNCTION [IMMUTABLE_STRING_32, G]
		a_object_comparison: BOOLEAN; a_manifest: STRING_32
	)
		require
			valid_manifest: valid_manifest (a_manifest)
		local
			line, key_string, item_string: IMMUTABLE_STRING_32; start_index, end_index: INTEGER
			line_split: EL_SPLIT_IMMUTABLE_STRING_32_ON_CHARACTER
			rs: EL_READABLE_STRING_GENERAL_ROUTINES
		do
			Immutable_32.set_item (a_manifest.area, 0, a_manifest.count)
			create line_split.make (Immutable_32.item, '%N')
			make (line_split.count)
			object_comparison := a_object_comparison
			across line_split as split loop
				line := split.item
				start_index := rs.start_plus_end_assignment_indices (line, $end_index)
				if end_index > 0 and start_index > 0 then
					key_string := line.shared_substring (1, end_index)
					item_string := line.shared_substring (start_index, line.count)
					extend (to_item (item_string), to_key (key_string))
				end
			end
		end

	make_from_manifest_8 (
		to_key: FUNCTION [IMMUTABLE_STRING_8, K]; to_item: FUNCTION [IMMUTABLE_STRING_8, G]
		a_object_comparison: BOOLEAN; a_manifest: STRING_8
	)
		require
			valid_manifest: valid_manifest (a_manifest)
		local
			line, key_string, item_string: IMMUTABLE_STRING_8; end_index, start_index: INTEGER
			line_split: EL_SPLIT_IMMUTABLE_STRING_8_ON_CHARACTER
			rs: EL_READABLE_STRING_GENERAL_ROUTINES
		do
			Immutable_8.set_item (a_manifest.area, 0, a_manifest.count)
			create line_split.make (Immutable_8.item, '%N')
			make (line_split.count)
			object_comparison := a_object_comparison

			across line_split as split loop
				line := split.item
				start_index := rs.start_plus_end_assignment_indices (line, $end_index)
				if end_index > 0 and start_index > 0 then
					key_string := line.shared_substring (1, end_index)
					item_string := line.shared_substring (start_index, line.count)
					extend (to_item (item_string), to_key (key_string))
				end
			end
		end

	make_from_map_list (map: EL_ARRAYED_MAP_LIST [K, G]; a_object_comparison: BOOLEAN)
		do
			make (map.count)
			object_comparison := a_object_comparison
			from map.start until map.after loop
				put (map.item_value, map.item_key)
				map.forth
			end
		end

	make_from_keys (key_container: CONTAINER [K]; to_item: FUNCTION [K, G]; a_object_comparison: BOOLEAN)
		require
			valid_open_operands: as_key_structure (key_container).valid_open_argument (to_item)
		local
			i, i_upper: INTEGER
		do
			if attached as_key_structure (key_container) as key_structure then
				make (key_structure.current_count)
				object_comparison := a_object_comparison

				if attached key_structure.to_special as key_area then
					i_upper := key_structure.current_count - 1
					from i := 0 until i > i_upper loop
						put (to_item (key_area [i]), key_area [i])
						check
							no_conflict: not conflict
						end
						i := i + 1
					end
				end
			else
				make (1)
				object_comparison := a_object_comparison
			end
		end

	make_one (key: K; new: G)
		do
			default_create
			put (new, key)
		end

feature -- Access

	item_list, linear_representation: EL_ARRAYED_LIST [G]
		local
			pos, last_index: INTEGER; break: BOOLEAN; area: SPECIAL [G]
		do
			create area.make_empty (count)
			if attached content as l_content and then attached deleted_marks as is_deleted then
				last_index := l_content.count - 1
				from pos := -1 until break loop
					pos := next_iteration_index (pos, last_index, is_deleted)
					if pos > last_index then
						break := True
					else
						area.extend (l_content [pos])
					end
				end
			end
			create Result.make_from_special (area)
		end

	key_array, current_keys: ARRAY [K]
		do
			create Result.make_from_special (key_list.area)
		end

	key_list: EL_ARRAYED_LIST [K]
		local
			pos, last_index: INTEGER; break: BOOLEAN; area: SPECIAL [K]
		do
			create area.make_empty (count)
			if attached keys as l_keys and then attached deleted_marks as is_deleted then
				last_index := l_keys.count - 1
				from pos := -1 until break loop
					pos := next_iteration_index (pos, last_index, is_deleted)
					if pos > last_index then
						break := True
					else
						area.extend (l_keys [pos])
					end
				end
			end
			create Result.make_from_special (area)
		end

	new_cursor: EL_HASH_TABLE_ITERATION_CURSOR [G, K]
			-- <Precursor>
		do
			create Result.make (Current)
			Result.start
		end

	tuple_for_iteration: TUPLE [value: G; key: K]
		do
			Result := [item_for_iteration, key_for_iteration]
		end

feature -- Status query

	is_key_sortable: BOOLEAN
		do
			Result := Eiffel.is_comparable_type (({K}).type_id)
		end

	is_sortable: BOOLEAN
		do
			Result := Eiffel.is_comparable_type (({G}).type_id)
		end

feature -- Element change

	append_tuples (array: like MANIFEST_ARRAY)
		local
			i, new_count: INTEGER; map: like as_map_list.item_tuple
		do
			new_count := count + array.count
			if new_count > capacity then
				accommodate (new_count)
			end
			from i := 1 until i > array.count loop
				map := array [i]
				force (map.value, map.key)
				i := i + 1
			end
		end

	merge (other: HASH_TABLE [G, K])
		do
			if attached {EL_HASH_TABLE [G, K]} other as el_other then
				el_other.merge_to (Current)
			else
				Precursor (other)
			end
		end

	plus alias "+" (tuple: like as_map_list.item_tuple): like Current
		do
			force (tuple.value, tuple.key)
			Result := Current
		end

feature -- Basic operations

	ascending_sort
		-- sort items in ascending order
		do
			sort (True)
		end

	merge_to (other: HASH_TABLE [G, K])
		local
			pos, last_index: INTEGER; break: BOOLEAN
		do
			if attached keys as l_keys and then attached content as l_content
				and then attached deleted_marks as is_deleted
			then
				last_index := l_keys.count - 1
				from pos := -1 until break loop
					pos := next_iteration_index (pos, last_index, is_deleted)
					if pos > last_index then
						break := True
					else
						other.force (l_content [pos], l_keys [pos])
					end
				end
			end
		end

	reverse_sort
		-- sort items in descending order
		do
			sort (False)
		end

	sort (in_ascending_order: BOOLEAN)
		require
			sortable_items: is_sortable
		do
			if attached {SPECIAL [COMPARABLE]} content as comparables then
				sort_comparables (comparables, in_ascending_order)
			end
		end

	sort_by_key (in_ascending_order: BOOLEAN)
		require
			sortable_items: is_key_sortable
		do
			if attached {SPECIAL [COMPARABLE]} keys as comparables then
				sort_comparables (comparables, in_ascending_order)
			end
		end

feature -- Conversion

	as_map_list: EL_ARRAYED_MAP_LIST [K, G]
		do
	 		create Result.make_from_keys (key_list, agent item)
	 	end

feature -- Contract Support

	item_cell: detachable CELL [like item]
		do
			if not off then
				create Result.put (item_for_iteration)
			end
		end

	valid_manifest (a_manifest: READABLE_STRING_GENERAL): BOOLEAN
		local
			rs: EL_READABLE_STRING_GENERAL_ROUTINES
		do
			Result := rs.valid_assignments (a_manifest)
		end

feature -- Type definitions

	MANIFEST_ARRAY: like as_map_list.MANIFEST_ARRAY
		-- type of array used to initialize `Current' in `make' routine
		require
			never_called: False
		do
			create Result.make_empty
		end

feature {EL_HASH_TABLE_ITERATION_CURSOR} -- Implementation

	current_container: CONTAINER [G]
		do
			Result := Current
		end

	next_iteration_index (a_position, last_index: INTEGER; is_deleted: like deleted_marks): INTEGER
		-- Given an iteration position, advanced to the next one taking into account deleted
		-- slots in the `content' and `keys' structures.
		require
			a_position_big_enough: a_position >= -1
			a_position_small_enough: a_position < keys.count
		do
			Result := a_position + 1
			from until Result > last_index or else not is_deleted [Result] loop
				Result := Result + 1
			end
		end

	sort_comparables (comparables: SPECIAL [COMPARABLE]; in_ascending_order: BOOLEAN)
		-- reorder table keys and items based on a sort of `comparables'
		-- and removing any deleted items
		local
			sorted_keys: like keys; sorted_content: like content
			i, new_index, last_index, new_iteration_position: INTEGER
			sorted: EL_SORTED_INDEX_LIST; old_key_item, key_item: like key_for_iteration
		do
			if count > 0 then
				create sorted.make (comparables, in_ascending_order)
				create sorted_keys.make_empty (count)
				create sorted_content.make_empty (count)
				if not off then
					old_key_item := key_for_iteration
				end
				if attached keys as l_keys and then attached content as l_content
					and then attached indexes_map as map_area
					and then attached sorted.area as index_area
					and then attached deleted_marks as is_deleted

				then
					new_iteration_position := count; last_index := index_area.count - 1
					from until i > last_index loop
						new_index := index_area [i]
						if not is_deleted [new_index] then
							key_item := l_keys [new_index]
							sorted_keys.extend (key_item)
							sorted_content.extend (l_content [new_index])
							if old_key_item = key_item then
								new_iteration_position := sorted_content.count - 1
							end
						end
						i := i + 1
					end
					wipe_out
					from i := 0 until i = sorted_keys.count loop
						extend (sorted_content [i], sorted_keys [i])
						i := i + 1
					end
					iteration_position := new_iteration_position
				end
			end
		ensure
			same_item: attached old item_cell as old_item implies old_item.item = item_for_iteration
		end

note
	descendants: "[
			EL_HASH_TABLE [G, K -> ${HASHABLE}]
				${EL_LOG_FILTER_SET [TYPE_LIST -> TUPLE create default_create end]}
				${EL_TYPE_TABLE [G]}
				${EL_CONFORMING_INSTANCE_TABLE [G]}
				${EL_COUNTER_TABLE [K -> HASHABLE]}
				${EL_OBJECTS_BY_TYPE}
				${EL_STRING_32_TABLE [G]}
				${EL_STRING_GENERAL_TABLE [G]}
				${EL_PASSPHRASE_EVALUATOR}
				${EL_EIF_OBJ_TEXT_TABLE_CONTEXT}
				${EL_STRING_ESCAPER [S -> STRING_GENERAL create make end]}
					${XML_ESCAPER [S -> STRING_GENERAL create make end]}
					${EL_CSV_ESCAPER [S -> STRING_GENERAL create make end]}
				${EL_STRING_HASH_TABLE [G, K -> STRING_GENERAL create make end]}
					${EL_ZSTRING_HASH_TABLE [G]}
						${EL_TRANSLATION_TABLE}
						${EL_MULTI_LANGUAGE_TRANSLATION_TABLE*}
							${EL_XML_ML_TRANSLATION_TABLE}
							${EL_PYXIS_ML_TRANSLATION_TABLE}
						${TB_ATTRIBUTE_EDIT_TABLE}
					${EL_PROCEDURE_TABLE [K -> STRING_GENERAL create make end]}
				${EL_FUNCTION_RESULT_TABLE [TARGET, R]}
				${EL_ZSTRING_TABLE}
					${EL_HTTP_COOKIE_TABLE}
				${EL_COMPRESSION_TABLE [G -> EL_STORABLE create make_default end, K -> HASHABLE]}
					${EL_GEOGRAPHIC_INFO_TABLE}
				${EL_INITIALIZED_OBJECT_FACTORY [F -> EL_FACTORY [G], G]}
					${EL_INITIALIZED_HASH_TABLE_FACTORY}
					${EL_INITIALIZED_FIELD_FACTORY}
					${EL_INITIALIZED_ARRAYED_LIST_FACTORY}
				${EL_ESCAPE_TABLE}
				${EL_IMMUTABLE_NAME_TABLE [N -> (NUMERIC, HASHABLE)]}
				${EL_CODE_TABLE [K -> HASHABLE]}
					${EL_UNIQUE_CODE_TABLE [K -> HASHABLE]}
						${EL_ZSTRING_TOKEN_TABLE}
							${EL_WORD_TOKEN_TABLE}
				${EL_IMMUTABLE_STRING_TABLE* [GENERAL -> STRING_GENERAL, IMMUTABLE_STRING_GENERAL]}
					${EL_IMMUTABLE_STRING_32_TABLE}
					${EL_IMMUTABLE_STRING_8_TABLE}
						${EL_IMMUTABLE_UTF_8_TABLE}
							${EL_IMMUTABLE_TRANSLATION_TABLE}
						${EL_TUPLE_FIELD_TABLE}
				${EL_URI_QUERY_HASH_TABLE* [STRING_GENERAL, EL_STRING_BUFFER [S, READABLE_STRING_GENERAL]]}
					${EL_URI_QUERY_STRING_32_HASH_TABLE}
					${EL_URI_QUERY_STRING_8_HASH_TABLE}
					${EL_URI_QUERY_ZSTRING_HASH_TABLE}
				${EL_STRING_8_TABLE [G]}
					${EL_FIELD_VALUE_TABLE [G]}
					${EL_DATE_FUNCTION_TABLE}
					${EVOLICITY_FUNCTION_TABLE}
					${EL_XPATH_TOKEN_TABLE}
				${EL_STRING_GENERAL_UNESCAPER* [R -> READABLE_STRING_GENERAL, G -> STRING_GENERAL]}
					${EL_STRING_8_UNESCAPER}
					${EL_STRING_32_UNESCAPER}
					${EL_ZSTRING_UNESCAPER}
						${JSON_UNESCAPER}
				${ECD_INDEX_TABLE* [G -> EL_STORABLE create make_default end, K -> HASHABLE]}
					${ECD_REFLECTIVE_INDEX_TABLE [G -> EL_REFLECTIVELY_SETTABLE_STORABLE, K -> HASHABLE]}
				${EL_LOCALE_TABLE}
				${XML_NAME_SPACE_TABLE}
				${EL_CACHE_TABLE* [G, K -> HASHABLE]}
					${EL_AGENT_CACHE_TABLE [G, K -> HASHABLE]}
					${EL_LOCALE_TEXTS_TABLE [EL_REFLECTIVE_LOCALE_TEXTS]}
					${EL_IP_ADDRESS_GEOLOCATION_TABLE [G -> EL_IP_ADDRESS_COUNTRY create make end]}
					${EL_FACTORY_TYPE_ID_TABLE}
					${EL_NAME_TRANSLATER_TABLE}
				${EVOLICITY_TEMPLATE_STACK_TABLE}
				${EL_SINGLETON_TABLE}
				${EL_FUNCTIONS_BY_RESULT_TYPE}
				${EL_FUNCTION_CACHE_TABLE [G, OPEN_ARGS -> TUPLE create default_create end]}
					${EL_FILLED_STRING_8_TABLE}
					${EL_LOCALIZED_CURRENCY_TABLE}
					${EL_FILLED_STRING_TABLE* [STR -> READABLE_STRING_GENERAL]}
						${EL_FILLED_STRING_32_TABLE}
						${EL_FILLED_ZSTRING_TABLE}
				${EL_XPATH_ACTION_TABLE}
				${EL_CURL_HEADER_TABLE}
				${EL_STRING_CONVERSION_TABLE}
				${EL_IMMUTABLE_KEY_8_TABLE [G]}
					${EL_FIELD_TABLE}
					${EL_OBJECT_FIELDS_TABLE}
				${EL_GROUPED_LIST_TABLE [G, K -> HASHABLE]}
					${EL_GROUPED_SET_TABLE [G, K -> HASHABLE]}
						${EL_FUNCTION_GROUPED_SET_TABLE [G, K -> HASHABLE]}
						${EL_URL_FILTER_TABLE}
					${EL_FUNCTION_GROUPED_LIST_TABLE [G, K -> HASHABLE]}
						${EL_FUNCTION_GROUPED_SET_TABLE [G, K -> HASHABLE]}
	]"
end