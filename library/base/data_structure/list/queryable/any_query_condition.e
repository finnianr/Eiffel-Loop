note
	description: "Summary description for {ANY_QUERY_CONDITION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
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