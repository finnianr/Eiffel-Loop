note
	description: "Summary description for {EL_FILTER_PREDICATES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-30 19:20:34 GMT (Tuesday 30th December 2014)"
	revision: "2"

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
