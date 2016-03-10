note
	description: "Summary description for {EL_QUERY_CONDITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_QUERY_CONDITION [G]

feature -- Access

	include (item: G): BOOLEAN
		deferred
		end

feature -- Addition

	conjuncted alias "and" (right: EL_QUERY_CONDITION [G]): EL_AND_QUERY_CONDITION [G]
		do
			create Result.make (Current, right)
		end

	disjuncted alias "or" (right: EL_QUERY_CONDITION [G]): EL_OR_QUERY_CONDITION [G]
		do
			create Result.make (Current, right)
		end

	negated alias "not": EL_NOT_QUERY_CONDITION [G]
		do
			create Result.make (Current)
		end

end
