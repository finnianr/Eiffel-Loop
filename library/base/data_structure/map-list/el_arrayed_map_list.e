note
	description: "Arrayed list of key-value pair tuples"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-27 18:43:19 GMT (Monday 27th March 2023)"
	revision: "22"

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
			has as has_key,
			put_front as put_key_front,
			search as key_search
		export
			{NONE} append, key_extend, put_key_front, prune, prune_all, put_left, put_right, replace
		redefine
			compare_objects, compare_references, make, new_cursor, remove
		end

create
	make, make_filled, make_from, make_empty, make_from_array,
	make_from_keys, make_from_table, make_from_values

feature {NONE} -- Initialization

	make_from_array (array: ARRAY [like item_tuple])
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
			i: INTEGER; wrapper: EL_CONTAINER_WRAPPER [K]
		do
			create wrapper.make (keys)
			make_from_special (wrapper.to_special)

			create internal_value_list.make (count)
			if attached internal_value_list.area_v2 as value_area
				and then attached area_v2 as key_area
			then
				from until i = key_area.count loop
					value_area.extend (to_value (key_area [i]))
					i := i + 1
				end
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
			i: INTEGER; wrapper: EL_CONTAINER_WRAPPER [G]
		do
			create wrapper.make (values)
			create internal_value_list.make_from_special (wrapper.to_special)
			create area_v2.make_empty (internal_value_list.count)

			if attached internal_value_list.area_v2 as value_area
				and then attached area_v2 as key_area
			then
				from until i = value_area.count loop
					key_area.extend (to_key (value_area [i]))
					i := i + 1
				end
			end
		end

	make (n: INTEGER)
		do
			Precursor (n)
			create internal_value_list.make (n)
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

	item_value: G
		require
			valid_index: valid_index (index)
		do
			Result := internal_value_list [index]
		end

	i_th_value (i: INTEGER): like item_value
		require
			valid_index: valid_index (i)
		do
			Result := internal_value_list [i]
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
		end

feature -- Status query

	has (pair: like item_tuple): BOOLEAN
		do
			push_cursor
				start; key_search (pair.key)
				if found then
					if object_comparison then
						Result := internal_value_list [index] ~ pair.value
					else
						Result := internal_value_list [index] = pair.value
					end
				end
			pop_cursor
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

	set_key_item (key: like item_key; value: like item_value)
		-- set first `item.value' with key matching `key' or else extend with new key-value tuple
		-- key comparison is either by object or reference depending on `object_comparison'
		do
			push_cursor
			start; key_search (key)
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

	compare_objects
			-- Ensure that future search operations will use `equal'
			-- rather than `=' for comparing references.
		do
			Precursor
			internal_value_list.compare_objects
		end

	compare_references
			-- Ensure that future search operations will use `='
			-- rather than `equal' for comparing references.
		do
			Precursor
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

feature -- Removal

	remove
		do
			internal_value_list.go_i_th (index)
			internal_value_list.remove
			Precursor
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

feature {ARRAYED_LIST_ITERATION_CURSOR} -- Internal attributes

	internal_value_list: EL_ARRAYED_LIST [G];

invariant
	same_key_value_counts: count = internal_value_list.count

note
	descendants: "[
			EL_ARRAYED_MAP_LIST [K, G]
				[$source EL_DECOMPRESSED_DATA_LIST]
				[$source EL_SORTABLE_ARRAYED_MAP_LIST]* [K, G]
					[$source EL_KEY_SORTABLE_ARRAYED_MAP_LIST] [K -> [$source COMPARABLE], G]
					[$source EL_VALUE_SORTABLE_ARRAYED_MAP_LIST] [K, G -> [$source COMPARABLE]]
				[$source EL_STYLED_TEXT_LIST]* [S -> [$source STRING_GENERAL]]
					[$source EL_STYLED_ZSTRING_LIST]
					[$source EL_STYLED_STRING_8_LIST]
					[$source EL_STYLED_STRING_32_LIST]
	]"

end