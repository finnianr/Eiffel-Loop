note
	description: "Predicate query condition"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-05 15:04:46 GMT (Monday 5th November 2018)"
	revision: "6"

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
