note
	description: "Summary description for {EL_AND_QUERY_CONDITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_AND_QUERY_CONDITION [G]

inherit
	EL_QUERY_CONDITION [G]

create
	make

feature {NONE} -- Initialization

	make (a_left, a_right: like left)
		do
			left := a_left; right := a_right
		end

feature -- Access

	include (item: G): BOOLEAN
		do
			Result := left.include (item) and then right.include (item)
		end

feature {NONE} -- Implementation

	left: EL_QUERY_CONDITION [G]

	right: like left
end
