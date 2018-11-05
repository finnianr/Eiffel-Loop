note
	description: "And query condition"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-04 11:48:41 GMT (Sunday 4th November 2018)"
	revision: "6"

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

	met (item: G): BOOLEAN
		-- True if both `left' and `right' condition is met `item'
		do
			Result := left.met (item) and then right.met (item)
		end

feature {NONE} -- Implementation

	left: EL_QUERY_CONDITION [G]

	right: like left
end
