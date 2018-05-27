note
	description: "Not query condition"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "4"

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

	include (item: G): BOOLEAN
		do
			Result := not condition.include (item)
		end

feature {NONE} -- Implementation

	condition: EL_QUERY_CONDITION [G]

end