note
	description: "Arrayed list of key-value pair tuples that can be sorted"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "4"

deferred class
	EL_SORTABLE_ARRAYED_MAP_LIST [K, G]

inherit
	EL_ARRAYED_MAP_LIST [K, G]

	PART_COMPARATOR [TUPLE [K, G]]
		undefine
			is_equal, copy
		end

feature -- Basic operations

	sort (in_ascending_order: BOOLEAN)
		do
			if in_ascending_order then
				sorter.sort (Current)
			else
				sorter.reverse_sort (Current)
			end
		end

feature {NONE} -- Implementation

	sorter: SORTER [like item]
		do
			if count < 50 then
				create {BUBBLE_SORTER [like item]} Result.make (Current)
			else
				create {QUICK_SORTER [like item]} Result.make (Current)
			end
		end
end