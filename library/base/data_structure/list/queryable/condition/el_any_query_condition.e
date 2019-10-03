note
	description: "Any query condition"
	tests: "[$source CHAIN_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-02 17:23:35 GMT (Wednesday   2nd   October   2019)"
	revision: "8"

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
