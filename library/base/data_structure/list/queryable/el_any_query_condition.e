note
	description: "Any query condition"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 16:29:36 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_ANY_QUERY_CONDITION [G]

inherit
	EL_QUERY_CONDITION [G]

feature -- Access

	include (item: G): BOOLEAN
		do
			Result := True
		end

end
