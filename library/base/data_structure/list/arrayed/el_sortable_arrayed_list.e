note
	description: "Sortable arrayed list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-30 12:20:32 GMT (Thursday 30th March 2023)"
	revision: "14"

class
	EL_SORTABLE_ARRAYED_LIST [G -> COMPARABLE]

inherit
	EL_ARRAYED_LIST [G]
		rename
			sort as sort_indirectly
		redefine
			reverse_sort, ascending_sort
		end

create
	make, make_empty, make_sorted, make_default_filled, make_filled,
	make_from_for, make_from, make_from_if,
	make_joined, make_from_special, make_from_array,
	make_from_sub_list, make_from_tuple

convert
	make_sorted ({CONTAINER [G]})

feature {NONE} -- Initialization

	make_sorted (container: CONTAINER [G])
		-- make sorted using object comparison
		do
			make_from (container)
			ascending_sort
		end

feature -- Basic operations

	reverse_sort
		-- sort in descending order
		do
			ascending_sort; reverse_order
		end

	ascending_sort
		-- sort in ascending order
		local
			array: SORTABLE_ARRAY [like item]
		do
			create array.make_from_array (to_array)
			array.sort
		end

end