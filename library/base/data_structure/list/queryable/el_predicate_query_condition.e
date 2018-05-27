note
	description: "Predicate query condition"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "5"

class
	EL_PREDICATE_QUERY_CONDITION [G]

inherit
	EL_QUERY_CONDITION [G]

create
	make

feature {NONE} -- Initialization

	make (a_predicate: like predicate)
		do
			create operands
			predicate := a_predicate
			predicate.set_operands (operands)
		end

feature -- Access

	include (item: G): BOOLEAN
		do
			operands.put_reference (item, 1)
			predicate.apply
			Result := predicate.last_result
		end

feature {NONE} -- Implementation

	operands: TUPLE [G]

	predicate: PREDICATE [G]

end