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
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "2"

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

	query (condition: EL_QUERY_CONDITION [G]): EL_QUERYABLE_ARRAYED_LIST [G]
			-- songs matching criteria
		do
			push_cursor
			create Result.make (count // 3)
			from start until after loop
				if condition.include (item) then
					Result.extend (item)
				end
				forth
			end
			pop_cursor
		end

feature -- Element change

	do_query (condition: EL_QUERY_CONDITION [G])
		do
			last_query_items := query (condition)
		end

end
