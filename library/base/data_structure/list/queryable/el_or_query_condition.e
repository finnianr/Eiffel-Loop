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
			include
		end

create
	make

feature -- Access

	include (item: G): BOOLEAN
		do
			Result := left.include (item) or else right.include (item)
		end
end