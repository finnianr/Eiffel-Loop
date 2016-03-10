note
	description: "Summary description for {EL_OR_QUERY_CONDITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_OR_QUERY_CONDITION [G]

inherit
	EL_AND_QUERY_CONDITION [G]
		redefine
			include
		end

create
	make

feature -- Access

	include (item: G): BOOLEAN
		do
			Result := left.include (item) or else right.include (item)
		end
end
