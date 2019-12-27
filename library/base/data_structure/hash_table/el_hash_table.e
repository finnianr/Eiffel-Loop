note
	description: "Hash table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-27 14:30:41 GMT (Friday 27th December 2019)"
	revision: "8"

class
	EL_HASH_TABLE [G, K -> HASHABLE]

inherit
	HASH_TABLE [G, K]
		rename
			make as make_size
		redefine
			default_create
		end

create
	 default_create, make, make_size, make_equal, make_from_map_list

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

feature -- Element change

	append_tuples (array: ARRAY [like as_map_list.item])
			--
		local
			i: INTEGER; map: like as_map_list.item
		do
			accommodate (count + array.count)
			from i := 1 until i > array.count loop
				map := array [i]
				force (map.value, map.key)
				i := i + 1
			end
		end

feature -- Constants

	as_map_list: EL_ARRAYED_MAP_LIST [K, G]
		do
	 		create Result.make_from_keys (current_keys, agent item)
	 	end

end
