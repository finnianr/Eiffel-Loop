note
	description: "Hash table with keys conforming to `READABLE_STRING_GENERAL'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-18 12:27:41 GMT (Friday 18th January 2019)"
	revision: "3"

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

	make (array: ARRAY [like GENERAL_MAP])
		do
			make_equal (array.count)
			merge_array (array)
		end

feature -- Element change

	merge_array (array: ARRAY [like GENERAL_MAP])
			--
		local
			i: INTEGER; map: like GENERAL_MAP
		do
			accommodate (count + array.count)
			from i := 1 until i > array.count loop
				map := array [i]
				force (map.value, map.key)
				i := i + 1
			end
		end

	plus alias "+" (tuple: like GENERAL_MAP): like Current
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

	GENERAL_MAP: TUPLE [key: READABLE_STRING_GENERAL; value: G]
		require
			never_called: False
		do
			create Result
		end
end
