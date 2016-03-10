note
	description: "Summary description for {EL_SORTABLE_ARRAYED_LIST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_SORTABLE_ARRAYED_LIST [G -> COMPARABLE]

inherit
	EL_ARRAYED_LIST [G]

create
	make, make_filled, make_from_array

feature -- Basic operations

	sort
		local
			l_array: SORTABLE_ARRAY [G]
		do
			create l_array.make_from_array (to_array)
			l_array.sort
		end

end
