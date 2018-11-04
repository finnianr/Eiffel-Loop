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

convert
	make ({PREDICATE [G]})

feature {NONE} -- Initialization

	make (a_predicate: like predicate)
		do
			create operands
			predicate := a_predicate
		end

feature -- Access

	met (item: G): BOOLEAN
		-- True if `predicate' applied to `item' is true
		do
			if operands_set then
				operands.put_reference (item, 1)
			else
				operands := [item]
				predicate.set_operands (operands)
			end
			predicate.apply
			Result := predicate.last_result
		end

feature {NONE} -- Implementation

	operands_set: BOOLEAN

	operands: TUPLE [G]

	predicate: PREDICATE [G]

end
