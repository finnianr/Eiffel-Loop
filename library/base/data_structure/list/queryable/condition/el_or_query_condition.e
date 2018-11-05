note
	description: "Or query condition"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-04 11:50:38 GMT (Sunday 4th November 2018)"
	revision: "6"

class
	EL_OR_QUERY_CONDITION [G]

inherit
	EL_AND_QUERY_CONDITION [G]
		redefine
			met
		end

create
	make

feature -- Access

	met (item: G): BOOLEAN
		-- True if either `left' or `right' condition is met for `item'
		do
			Result := left.met (item) or else right.met (item)
		end
end
