note
	description: "Hash table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-31 17:21:04 GMT (Friday 31st March 2023)"
	revision: "19"

class
	EL_HASH_TABLE [G, K -> HASHABLE]

inherit
	HASH_TABLE [G, K]
		rename
			make as make_size
		redefine
			default_create, new_cursor
		end

	EL_MODULE_EIFFEL; EL_MODULE_ITERABLE

create
	 default_create, make, make_size, make_equal, make_from_map_list, make_from_values

feature {NONE} -- Initialization

	default_create
			--
		do
			make_equal (3)
		end

	make (array: ARRAY [like as_map_list.item_tuple])
			--
		do
			make_equal (array.count)
			append_tuples (array)
		end

	make_from_map_list (map: EL_ARRAYED_MAP_LIST [K, G]; compare_equal: BOOLEAN)
		do
			if compare_equal then
				make_equal (map.count)
			else
				make_size (map.count)
			end
			from map.start until map.after loop
				put (map.item_value, map.item_key)
				map.forth
			end
		end

	make_from_values (list: ITERABLE [G]; to_key: FUNCTION [G, K]; compare_equal: BOOLEAN)
		do
			if compare_equal then
				make_equal (Iterable.count (list))
			else
				make_size (Iterable.count (list))
			end
			across list as value loop
				extend (value.item, to_key (value.item))
			end
		end

feature -- Access

	new_cursor: EL_HASH_TABLE_ITERATION_CURSOR [G, K]
			-- <Precursor>
		do
			create Result.make (Current)
			Result.start
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

	append_tuples (array: ARRAY [like as_map_list.item_tuple])
			--
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

	sort (in_ascending_order: BOOLEAN)
		require
			sortable_items: is_sortable
		do
			if attached {SPECIAL [COMPARABLE]} content as comparables then
				sort_comparables (comparables, in_ascending_order)
			end
		end

	reverse_sort
		-- sort items in descending order
		do
			sort (False)
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
	 		create Result.make_from_keys (current_keys, agent item)
	 	end

feature -- Contract Support

	item_cell: detachable CELL [like item]
		do
			if not off then
				create Result.put (item_for_iteration)
			end
		end

feature {NONE} -- Implementation

	sort_comparables (comparables: SPECIAL [COMPARABLE]; in_ascending_order: BOOLEAN)
		-- reorder table keys and items based on a sort of `comparables'
		local
			sorted_keys: like keys; sorted_content: like content
			i, new_index, new_iteration_position: INTEGER
			sorted: EL_SORTED_INDEX_LIST; l_item, content_item: detachable like item
		do
			if count > 0 then
				create sorted.make (comparables, in_ascending_order)
				create sorted_keys.make_empty (count)
				create sorted_content.make_empty (count)
				if not off then
					l_item := item_for_iteration
				end
				if attached keys as l_keys and then attached content as l_content
					and then attached indexes_map as map_area
					and then attached sorted.area as index_area
					and then attached deleted_marks as deleted_area

				then
					new_iteration_position := count
					from until i = index_area.count loop
						new_index := index_area [i]
						if not deleted_area [new_index] then
							sorted_keys.extend (l_keys [new_index])
							content_item := l_content [new_index]
							sorted_content.extend (content_item)
							if content_item = l_item then
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
end