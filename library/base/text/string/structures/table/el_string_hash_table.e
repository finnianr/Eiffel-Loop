note
	description: "Hash table with keys conforming to ${READABLE_STRING_GENERAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 14:05:10 GMT (Sunday 22nd September 2024)"
	revision: "10"

class
	EL_STRING_HASH_TABLE [G, K -> STRING_GENERAL create make end]

inherit
	EL_HASH_TABLE [G, K]
		rename
			make_assignments as make_from_tuples,
			force as force_key
		end

create
	default_create, make, make_equal, make_assignments

feature {NONE} -- Initialization

	make_assignments (array: ARRAY [like ASSIGNMENT])
		do
			make_equal (array.count)
			merge_array (array)
		end

feature -- Element change

	force (value: G; a_key: READABLE_STRING_GENERAL)
		do
			force_key (value, new_key (a_key))
		end

	merge_array (array: ARRAY [like ASSIGNMENT])
			--
		local
			i: INTEGER; map: like ASSIGNMENT
		do
			accommodate (count + array.count)
			from i := 1 until i > array.count loop
				map := array [i]
				force (map.value, map.key)
				i := i + 1
			end
		end

feature -- Type definitions

	ASSIGNMENT: TUPLE [key: READABLE_STRING_GENERAL; value: G]
		require
			never_called: False
		do
			create Result
		end

feature {NONE} -- Implementation

	new_key (general_key: READABLE_STRING_GENERAL): K
		do
			if attached {K} general_key as key then
				Result := key
			else
				create Result.make (general_key.count)
				Result.append (general_key)
			end
		end
end