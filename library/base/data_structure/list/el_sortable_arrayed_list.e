note
	description: "Summary description for {EL_SORTABLE_ARRAYED_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "2"

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

	sort
		local
			l_array: SORTABLE_ARRAY [G]
		do
			create l_array.make_from_array (to_array)
			l_array.sort
		end

end