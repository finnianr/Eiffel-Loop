note
	description: "Sortable arrayed list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-24 5:26:03 GMT (Sunday 24th September 2023)"
	revision: "15"

class
	EL_SORTABLE_ARRAYED_LIST [G -> COMPARABLE]

inherit
	EL_ARRAYED_LIST [G]
		redefine
			sort
		end

	PART_COMPARATOR [G]
		undefine
			copy, is_equal
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

	sort (in_ascending_order: BOOLEAN)
		local
			quick: QUICK_SORTER [G]
		do
			create quick.make (Current)
			if in_ascending_order then
				quick.sort (Current)
			else
				quick.reverse_sort (Current)
			end
		end

feature {NONE} -- Implementation

	less_than (u, v: G): BOOLEAN
		do
			Result := u.is_less (v)
		end

end