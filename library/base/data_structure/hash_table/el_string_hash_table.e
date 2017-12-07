note
	description: "Hash table with keys conforming to `READABLE_STRING_GENERAL'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-02 9:24:32 GMT (Saturday 2nd December 2017)"
	revision: "1"

class
	EL_STRING_HASH_TABLE [G, K -> STRING_GENERAL create make end]

inherit
	EL_HASH_TABLE [G, K]
		rename
			make as make_from_array,
			force as force_key
		end

create
	make, make_size, make_equal, default_create

feature {NONE} -- Initialization

	make (array: ARRAY [like MAP_ITEM])
		do
			make_equal (array.count)
			merge_array (array)
		end

feature -- Element change

	merge_array (array: ARRAY [like MAP_ITEM])
			--
		local
			i: INTEGER; map: like MAP_ITEM
		do
			accommodate (count + array.count)
			from i := 1 until i > array.count loop
				map := array [i]
				force (map.value, map.key)
				i := i + 1
			end
		end

	plus alias "+" (tuple: like MAP_ITEM): like Current
		do
			force (tuple.value, tuple.key)
			Result := Current
		end

	force (value: G; a_key: READABLE_STRING_GENERAL)
		local
			l_key: K
		do
			if attached {K} a_key as key then
				force_key (value, key)
			else
				create l_key.make (a_key.count)
				l_key.append (a_key)
				force_key (value, l_key)
			end
		end

feature -- Type definitions

	MAP_ITEM: TUPLE [key: READABLE_STRING_GENERAL; value: G]
		do
			create Result
		end
end
