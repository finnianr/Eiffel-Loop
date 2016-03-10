note
	description: "Summary description for {EL_FILTER_PREDICATES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_QUERY_CONDITION_FACTORY [G]

feature -- Access

	any: ANY_QUERY_CONDITION [G]
		do
			create Result
		end

	all_of (conditions: ARRAY [EL_QUERY_CONDITION [G]]): EL_ALL_OF_QUERY_CONDITION [G]
		do
			create Result.make (conditions)
		end

	one_of (conditions: ARRAY [EL_QUERY_CONDITION [G]]): EL_ONE_OF_QUERY_CONDITION [G]
		do
			create Result.make (conditions)
		end

	predicate (a_predicate: PREDICATE [ANY, TUPLE [G]]): EL_PREDICATE_QUERY_CONDITION [G]
		do
			create Result.make (a_predicate)
		end

end
