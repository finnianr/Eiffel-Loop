note
	description: "[
		A chain that is queryable using query condition objects that can be combined using the
		Eiffel logical operators: `and', `or', `not'.
	]"
	notes: "[
		Access more query constructs by inheriting class `${EL_QUERY_CONDITION_FACTORY}'
		in client classes.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "8"

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