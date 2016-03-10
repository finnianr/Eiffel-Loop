note
	description: "Summary description for {EL_PREDICATE_QUERY_CONDITION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-30 14:53:42 GMT (Tuesday 30th December 2014)"
	revision: "2"

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

	predicate: PREDICATE [ANY, TUPLE [G]]

end
