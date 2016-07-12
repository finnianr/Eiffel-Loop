note
	description: "Summary description for {EL_NOT_QUERY_CONDITION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-30 15:02:33 GMT (Tuesday 30th December 2014)"
	revision: "2"

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
