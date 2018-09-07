note
	description: "And query condition"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_AND_QUERY_CONDITION [G]

inherit
	EL_QUERY_CONDITION [G]

create
	make

feature {NONE} -- Initialization

	make (a_left, a_right: like left)
		do
			left := a_left; right := a_right
		end

feature -- Access

	include (item: G): BOOLEAN
		do
			Result := left.include (item) and then right.include (item)
		end

feature {NONE} -- Implementation

	left: EL_QUERY_CONDITION [G]

	right: like left
end