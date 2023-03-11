note
	description: "Condition is met if [$source EL_STORABLE] item is deleted"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-10 10:10:55 GMT (Friday 10th March 2023)"
	revision: "2"

class
	EL_IS_DELETED_CONDITION [G -> EL_STORABLE]

inherit
	EL_QUERY_CONDITION [G]

feature -- Access

	met (item: G): BOOLEAN
		-- True if condition is met for `item`
		do
			Result := item.is_deleted
		end
end