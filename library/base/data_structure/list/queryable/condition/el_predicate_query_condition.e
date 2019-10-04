note
	description: "Predicate query condition"
	tests: "Class [$source CHAIN_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-04 13:16:10 GMT (Friday   4th   October   2019)"
	revision: "9"

class
	EL_PREDICATE_QUERY_CONDITION [G]

inherit
	EL_ROUTINE_QUERY_CONDITION [G]
		rename
			routine as predicate
		redefine
			predicate, met
		end

create
	make

convert
	make ({PREDICATE [G]})

feature -- Access

	met (item: G): BOOLEAN
		-- True if `predicate' applied to `item' is true
		do
			Result := Precursor (item) or else predicate.last_result
		end

feature {NONE} -- Implementation

	predicate: PREDICATE [G]

end
