note
	description: "Or query condition"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-08 11:35:15 GMT (Tuesday 8th August 2023)"
	revision: "8"

class
	EL_OR_QUERY_CONDITION [G]

inherit
	EL_AND_QUERY_CONDITION [G]
		redefine
			met
		end

create
	make

feature -- Status query

	met (item: G): BOOLEAN
		-- True if either `left' or `right' condition is met for `item'
		do
			Result := left.met (item) or else right.met (item)
		end
end