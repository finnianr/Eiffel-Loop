note
	description: "Query condition that returns **True** for every item if type **G**"
	tests: "Class ${CONTAINER_STRUCTURE_TEST_SET}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-08 11:34:47 GMT (Tuesday 8th August 2023)"
	revision: "13"

class
	EL_ANY_QUERY_CONDITION [G]

inherit
	EL_QUERY_CONDITION [G]

feature -- Status query

	met (item: G): BOOLEAN
		-- True for any `item'
		do
			Result := True
		end

end