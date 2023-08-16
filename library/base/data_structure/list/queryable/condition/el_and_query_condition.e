note
	description: "And query condition"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-08 11:34:44 GMT (Tuesday 8th August 2023)"
	revision: "8"

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

feature -- Status query

	met (item: G): BOOLEAN
		-- True if both `left' and `right' condition is met `item'
		do
			Result := left.met (item) and then right.met (item)
		end

feature {NONE} -- Implementation

	left: EL_QUERY_CONDITION [G]

	right: like left
end