note
	description: "Hash table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-26 15:51:48 GMT (Sunday 26th December 2021)"
	revision: "13"

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

	make (array: ARRAY [like as_map_list.item])
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

	append_tuples (array: ARRAY [like as_map_list.item])
			--
		local
			i, new_count: INTEGER; map: like as_map_list.item
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

	plus alias "+" (tuple: like as_map_list.item): like Current
		do
			force (tuple.value, tuple.key)
			Result := Current
		end

feature -- Constants

	as_map_list: EL_ARRAYED_MAP_LIST [K, G]
		do
	 		create Result.make_from_keys (current_keys, agent item)
	 	end

end