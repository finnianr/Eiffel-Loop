note
	description: "Hash table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-30 14:39:55 GMT (Thursday 30th March 2023)"
	revision: "18"

class
	EL_HASH_TABLE [G, K -> HASHABLE]

inherit
	HASH_TABLE [G, K]
		rename
			make as make_size
		redefine
			default_create, new_cursor
		end

	EL_MODULE_ITERABLE

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

	reorder (sorted: EL_SORTED_INDEX_LIST)
		-- reorder table keys and items based on a sort of `comparables'
		require
			same_number: count = sorted.count
		local
			sorted_keys: like keys
			i, old_iteration_position, new_index: INTEGER
		do
			if count > 0 then
				old_iteration_position := old_iteration_position
				create sorted_keys.make_empty (count)
				if attached keys as l_keys and then attached sorted.area as index_area then
					from until i = index_area.count loop
--						if attached l_keys [index_area [i] - 1] as l_item then
--							sorted_keys.extend (l_item)
--							if index_item = old_iteration_position then
--								iteration_position := index_item
--							end
--						end
						i := i + 1
					end
				end
				keys := sorted_keys
			end
		ensure
			same_item: attached old item_cell as old_item implies old_item.item = item_for_iteration
		end
end