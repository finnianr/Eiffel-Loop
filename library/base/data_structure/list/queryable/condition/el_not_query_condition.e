note
	description: "Not query condition"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-08 11:35:07 GMT (Tuesday 8th August 2023)"
	revision: "8"

class
	EL_NOT_QUERY_CONDITION [G]

inherit
	EL_QUERY_CONDITION [G]

create
	make

feature {NONE} -- Initialization

	make (a_condition: like condition)
		do
			condition := a_condition
		end

feature -- Status query

	met (item: G): BOOLEAN
		-- True if `condition' is not met for `item'
		do
			Result := not condition.met (item)
		end

feature {NONE} -- Implementation

	condition: EL_QUERY_CONDITION [G]

end