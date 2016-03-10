note
	description: "Summary description for {EL_FILTERABLE_CHAIN}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-12-18 10:43:05 GMT (Wednesday 18th December 2013)"
	revision: "3"

deferred class EL_QUERYABLE_CHAIN [G]

inherit
	CHAIN [G]

feature {NONE} -- Initialization

	make_chain
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
			create Result.make (count // 3)
			from start until after loop
				if condition.include (item) then
					Result.extend (item)
				end
				forth
			end
		end

feature -- Element change

	do_query (condition: EL_QUERY_CONDITION [G])
		do
			last_query_items := query (condition)
		end

end
