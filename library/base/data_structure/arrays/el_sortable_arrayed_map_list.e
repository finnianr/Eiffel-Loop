note
	description: "Arrayed list of key-value pair tuples that can be sorted by key of type `K'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-24 11:44:08 GMT (Saturday 24th February 2018)"
	revision: "2"

class
	EL_SORTABLE_ARRAYED_MAP_LIST [K -> {HASHABLE, COMPARABLE}, G]

inherit
	EL_ARRAYED_MAP_LIST [K, G]

	PART_COMPARATOR [TUPLE [K, G]]
		undefine
			is_equal, copy
		end

create
	make, make_filled, make_from_array, make_empty, make_from_table

feature -- Basic operations

	sort
		local
			quick: QUICK_SORTER [like item]
		do
			create quick.make (Current)
			quick.sort (Current)
		end

feature {NONE} -- Implementation

	less_than (a, b: like item): BOOLEAN
		do
			Result := a.key < b.key
		end

end
