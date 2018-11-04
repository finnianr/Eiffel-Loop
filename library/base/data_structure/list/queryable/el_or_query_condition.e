note
	description: "Or query condition"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "5"

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
