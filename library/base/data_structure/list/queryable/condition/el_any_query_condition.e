note
	description: "Query condition that returns **True** for every item if type **G**"
	tests: "Class ${CONTAINER_STRUCTURE_TEST_SET}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "14"

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