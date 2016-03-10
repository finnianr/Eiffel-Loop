note
	description: "Summary description for {EL_HASH_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 11:06:17 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	EL_HASH_TABLE [G, K -> HASHABLE]

inherit
	HASH_TABLE [G, K]
		rename
			make as make_with_count
		redefine
			default_create
		end

create
	make, make_with_count, default_create

feature {NONE} -- Initialization

	make (array: ARRAY [TUPLE [K, G]])
			--
		do
			make_with_count (array.count)
			append_tuples (array)
		end

	default_create
			--
		do
			make_with_count (3)
		end

feature -- Element change

	append_tuples (array: ARRAY [TUPLE [K, G]])
			--
		local
			i: INTEGER
		do
			accommodate (count + array.count)
			from i := 1 until i > array.count loop
				force_tuple (array [i])
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	force_tuple (a_tuple: TUPLE [K, G])
		do
			if attached {K} a_tuple.item (1) as key and then attached {G} a_tuple.item (2) as item_ref then
				force (item_ref, key)
			end
		end

end
