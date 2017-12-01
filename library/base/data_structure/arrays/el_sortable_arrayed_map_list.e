note
	description: "Arrayed list of key-value pair tuples that can be sorted by key of type `K'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-16 14:27:47 GMT (Thursday 16th November 2017)"
	revision: "1"

class
	EL_SORTABLE_ARRAYED_MAP_LIST [K -> {HASHABLE, COMPARABLE}, G]

inherit
	EL_ARRAYED_MAP_LIST [K, G]

create
	make, make_filled, make_from_array, make_empty, make_from_table

feature -- Basic operations

	sort
		local
			quick: QUICK_SORTER [like item]
		do
			create quick.make (new_index_comparator)
			quick.sort (Current)
		end

feature {NONE} -- Implementation

	less_than (a, b: like item): BOOLEAN
			-- do nothing comparator
		do
			Result := a.key < b.key
		end

	new_index_comparator: AGENT_EQUALITY_TESTER [like item]
		do
			create Result.make (agent less_than)
		end

end
