note
	description: "Not query condition"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-04 11:49:42 GMT (Sunday 4th November 2018)"
	revision: "6"

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

feature -- Access

	met (item: G): BOOLEAN
		-- True if `condition' is not met for `item'
		do
			Result := not condition.met (item)
		end

feature {NONE} -- Implementation

	condition: EL_QUERY_CONDITION [G]

end
