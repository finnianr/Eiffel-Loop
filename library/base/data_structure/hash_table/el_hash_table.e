note
	description: "Summary description for {EL_HASH_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-02 11:08:02 GMT (Saturday 2nd December 2017)"
	revision: "4"

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
	make, make_size, make_equal, default_create

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
	 		create Result.make_from_table (Current)
	 	end

end
