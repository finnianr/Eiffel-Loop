note
	description: "Summary description for {ANY_QUERY_CONDITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ANY_QUERY_CONDITION [G]

inherit
	EL_QUERY_CONDITION [G]

feature -- Access

	include (item: G): BOOLEAN
		do
			Result := True
		end

end
