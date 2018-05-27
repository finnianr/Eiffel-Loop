note
	description: "Sortable arrayed list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "6"

class
	EL_SORTABLE_ARRAYED_LIST [G -> COMPARABLE]

inherit
	EL_ARRAYED_LIST [G]

create
	make, make_filled, make_from_array, make_sorted

convert
	make_sorted ({FINITE [G]})

feature {NONE} -- Initialization

	make_sorted (finite: FINITE [G])
		-- make sorted using object comparison
		local
			linear: LINEAR [G]
		do
			make (finite.count)
			linear := finite.linear_representation
			from linear.start until linear.after loop
				extend (linear.item)
				linear.forth
			end
			compare_objects; sort
		end

feature -- Basic operations

	reverse_sort
		local
			array: ARRAY [like item]; i: INTEGER
		do
			sort
			array := to_array
			make (array.count)
			from i := array.count until i = 0 loop
				extend (array [i])
				i := i - 1
			end
		end

	sort
		local
			array: SORTABLE_ARRAY [like item]
		do
			create array.make_from_array (to_array)
			array.sort
		end

end
