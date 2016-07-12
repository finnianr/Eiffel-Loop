note
	description: "Summary description for {EL_OR_QUERY_CONDITION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-30 15:05:20 GMT (Tuesday 30th December 2014)"
	revision: "2"

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
