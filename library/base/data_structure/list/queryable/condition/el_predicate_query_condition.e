note
	description: "Predicate query condition"
	tests: "Class ${CONTAINER_STRUCTURE_TEST_SET}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "13"

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

feature -- Status query

	met (item: G): BOOLEAN
		-- True if `predicate' applied to `item' is true
		do
			Result := Precursor (item) or else predicate.last_result
		end

feature {NONE} -- Implementation

	predicate: PREDICATE [G]

end