note
	description: "Query condition that returns **True** for every item if type **G**"
	tests: "Class [$source CHAIN_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "11"

class
	EL_ANY_QUERY_CONDITION [G]

inherit
	EL_QUERY_CONDITION [G]

feature -- Access

	met (item: G): BOOLEAN
		-- True for any `item'
		do
			Result := True
		end

end