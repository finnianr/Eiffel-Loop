note
	description: "Arrayed list of key-value pair tuples"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-19 11:31:07 GMT (Friday 19th July 2024)"
	revision: "32"

class
	EL_ARRAYED_MAP_LIST [K, G]

inherit
	EL_ARRAYED_LIST [K]
		rename
			do_all as do_all_keys,
			extend as key_extend,
			first as first_key,
			last as last_key,
			make_from_array as make_from_key_array,
			item as item_key,
			i_th as i_th_key,
			is_sortable as is_key_sortable,
			has as has_key,
			put_front as put_key_front,
			replace as replace_key,
			sort as sort_by_key,
			search as search_key
		export
			{NONE} append, duplicate, key_extend, merge_left, merge_right,
				put_key_front, prune, prune_all, put_left, put_right,
				remove_left, remove_right, swap
		redefine
			make, new_cursor, remove, sort_by_key, wipe_out, grow, resize, trim
		end

create
	make, make_filled, make_from, make_empty, make_from_array,
	make_from_keys, make_from_table, make_from_values

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor (n)
			create internal_value_list.make (n)
		end

	make_from_array (array: like MANIFEST_ARRAY)
		do
			make (array.count)
			across array as list loop
				extend (list.item.key, list.item.value)
			end
		end

	make_from_keys (keys: CONTAINER [K]; to_value: FUNCTION [K, G])
		-- make from container of `keys' using `to_value' to generate value for each key
		require
			valid_function: key_item (keys).is_valid_for (to_value)
		local
			l_value_list: EL_ARRAYED_RESULT_LIST [K, G]
		do
			if keys.is_empty then
				make_empty
			else
				make_from (keys)
				create l_value_list.make (keys, to_value)
				internal_value_list := l_value_list.to_list
			end
		end

	make_from_table (table: TABLE_ITERABLE [G, K])
		do
			make (Iterable.count (table))
			across table as value loop
				extend (value.key, value.item)
			end
		end

	make_from_values (values: CONTAINER [G]; to_key: FUNCTION [G, K])
		-- make from container of `values' using `to_key' to generate key for each value
		require
			valid_function: value_item (values).is_valid_for (to_key)
		local
			l_key_list: EL_ARRAYED_RESULT_LIST [G, K]
		do
			if values.is_empty then
				make_empty
			else
				create internal_value_list.make_from (values)
				create l_key_list.make (values, to_key)
				make_from_special (l_key_list.area)
			end
		end

feature -- Access

	item_tuple: TUPLE [key: K; value: G]
		require
			valid_item_key: not off
		do
			Result := [item_key, internal_value_list [index]]
		end

	key_list: EL_ARRAYED_LIST [K]
		do
			create Result.make_from_special (area_v2.twin)
			if object_comparison then
				Result.compare_objects
			end
		end

	new_cursor: EL_ARRAYED_MAP_ITERATION_CURSOR [K, G]
		do
			create Result.make (Current)
		end

feature -- Value items

	first_value: like item_value
		require
			valid_count: count > 0
		do
			Result := internal_value_list.first
		end

	i_th_value (i: INTEGER): like item_value
		require
			valid_index: valid_index (i)
		do
			Result := internal_value_list [i]
		end

	item_value: G
		require
			valid_index: valid_index (index)
		do
			Result := internal_value_list [index]
		end

	last_value: like item_value
		require
			valid_count: count > 0
		do
			Result := internal_value_list.last
		end

	value_list: EL_ARRAYED_LIST [G]
		do
			create Result.make_from_special (internal_value_list.area.twin)
			if value_object_comparison then
				Result.compare_objects
			end
		end

feature -- Status query

	has (pair: like item_tuple): BOOLEAN
		do
			push_cursor
				start; search_key (pair.key)
				if found then
					if object_comparison then
						Result := internal_value_list [index] ~ pair.value
					else
						Result := internal_value_list [index] = pair.value
					end
				end
			pop_cursor
		end

	is_value_sortable: BOOLEAN
		do
			Result := Eiffel.is_comparable_type (({G}).type_id)
		end

	value_object_comparison: BOOLEAN
		do
			Result := internal_value_list.object_comparison
		end

feature -- Element change

	extend (key: K; value: G)
		do
			key_extend (key)
			internal_value_list.extend (value)
		end

	put_front (key: K; value: G)
		do
			put_key_front (key)
			internal_value_list.put_front (value)
		end

	put_i_th_value (a_value: G; i: INTEGER)
		require
			valid_index: valid_index (i)
		do
			internal_value_list.put_i_th (a_value, i)
		end

	replace (key: K; value: G)
		do
			replace_key (key)
			internal_value_list.put_i_th (value, index)
		end

	replace_value (value: G)
		require
			valid_item: not off
		do
			internal_value_list.put_i_th (value, index)
		end

	set_key_item (key: like item_key; value: like item_value)
		-- set first `item.value' with key matching `key' or else extend with new key-value tuple
		-- key comparison is either by object or reference depending on `object_comparison'
		do
			push_cursor
			start; search_key (key)
			if found then
				internal_value_list.put_i_th (value, index)
			else
				extend (key, value)
			end
			pop_cursor
		end

	set_last_value (a_value: G)
		local
			i: INTEGER
		do
			i := internal_value_list.count
			if i > 0 then
				internal_value_list.put_i_th (a_value, i)
			end
		end

feature -- Status setting

	compare_value_objects
		-- Ensure that future search operations will use `equal'
		-- rather than `=' for comparing references.
		do
			internal_value_list.compare_objects
		end

	compare_value_references
		-- Ensure that future search operations will use `='
		-- rather than `equal' for comparing references.
		do
			internal_value_list.compare_references
		end

feature -- Basic operations

	do_all (action: PROCEDURE [K, G])
		local
			i: INTEGER
		do
			if attached internal_value_list.area_v2 as value_area
				and then attached area_v2 as key_area
			then
				from until i = key_area.count loop
					action (key_area [i], value_area [i])
					i := i + 1
				end
			end
		end

	sort_by_key (in_ascending_order: BOOLEAN)
		do
			if attached {SPECIAL [COMPARABLE]} area as comparables then
				sort_comparables (comparables, in_ascending_order)
			end
		end

	sort_by_value (in_ascending_order: BOOLEAN)
		require
			sortable_by_value: is_value_sortable
		do
			if attached {SPECIAL [COMPARABLE]} internal_value_list.area as comparables then
				sort_comparables (comparables, in_ascending_order)
			end
		end

feature -- Removal

	remove
		do
			internal_value_list.go_i_th (index)
			internal_value_list.remove
			Precursor
		end

	wipe_out
		do
			Precursor
			internal_value_list.wipe_out
		end

feature -- Resizing

	grow (i: INTEGER)
			-- Change the capacity to at least `i'.
		do
			Precursor (i)
			internal_value_list.grow (i)
		end

	resize (new_capacity: INTEGER)
			-- Resize list so that it can contain
			-- at least `n' items. Do not lose any item.
		do
			Precursor (new_capacity)
			internal_value_list.resize (new_capacity)
		end

	trim
		do
			Precursor
			internal_value_list.trim
		end

feature -- Contract Support

	key_item (keys: CONTAINER [K]): EL_CONTAINER_ITEM [K]
		do
			create Result.make (keys)
		end

	value_item (values: CONTAINER [G]): EL_CONTAINER_ITEM [G]
		do
			create Result.make (values)
		end

feature -- Type definitions

	MANIFEST_ARRAY: ARRAY [like item_tuple]
		-- type of array used to initialize `Current' in `make_from_array' routine
		require
			never_called: False
		do
			create Result.make_empty
		end

feature {NONE} -- Implementation

	sort_comparables (comparables: SPECIAL [COMPARABLE]; in_ascending_order: BOOLEAN)
		local
			sorted: EL_SORTED_INDEX_LIST
		do
			create sorted.make (comparables, in_ascending_order)
			reorder (sorted)
			internal_value_list.reorder (sorted)
		end

feature {ARRAYED_LIST_ITERATION_CURSOR} -- Internal attributes

	internal_value_list: EL_ARRAYED_LIST [G];

invariant
	same_key_value_counts: count = internal_value_list.count

note
	descendants: "[
			EL_ARRAYED_MAP_LIST [K, G]
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
	]"

end