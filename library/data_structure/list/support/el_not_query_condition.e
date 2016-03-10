note
	description: "Summary description for {EL_NOT_QUERY_CONDITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_NOT_QUERY_CONDITION [G]

inherit
	EL_QUERY_CONDITION [G]

create
	make

feature {NONE} -- Initialization

	make (a_condition: like condition)
		do
			condition := a_condition
		end

feature -- Access

	include (item: G): BOOLEAN
		do
			Result := not condition.include (item)
		end

feature {NONE} -- Implementation

	condition: EL_QUERY_CONDITION [G]

end
