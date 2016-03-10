note
	description: "Summary description for {EL_ONE_OF_QUERY_CONDITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_ONE_OF_QUERY_CONDITION [G]

inherit
	EL_QUERY_CONDITION [G]

create
	make

feature {NONE} -- Initialization

	make (a_conditions: like conditions)
		do
			conditions := a_conditions
		end

feature -- Access

	include (item: G): BOOLEAN
		do
			across conditions as condition until Result loop
				Result := condition.item.include (item)
			end
		end

feature {NONE} -- Implementation

	conditions: ARRAY [EL_QUERY_CONDITION [G]]

end
