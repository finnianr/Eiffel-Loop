note
	description: "[
		A chain that is queryable using query condition objects that can be combined using the
		Eiffel logical operators: `and', `or', `not'.
		
		Access more query constructs by inheriting class `[$source EL_QUERY_CONDITION_FACTORY]'
		in client classes.
	]"
	notes: "[

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "4"

deferred class EL_QUERYABLE_CHAIN [G]

inherit
	EL_CHAIN [G]

feature {NONE} -- Initialization

	make_queryable
		do
			create last_query_items.make (0)
		end

feature -- Access

	last_query_items: EL_ARRAYED_LIST [G]
			-- songs matching criteria
			-- Cannot be made queryable as it would create an infinite loop on creation

feature -- Element change

	do_query (condition: EL_QUERY_CONDITION [G])
		do
			last_query_items := query (condition)
		end

end
