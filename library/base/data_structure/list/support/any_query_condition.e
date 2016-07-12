note
	description: "Summary description for {ANY_QUERY_CONDITION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-30 18:11:35 GMT (Tuesday 30th December 2014)"
	revision: "2"

class
	ANY_QUERY_CONDITION [G]

inherit
	EL_QUERY_CONDITION [G]

feature -- Access

	include (item: G): BOOLEAN
		do
			Result := True
		end

end
