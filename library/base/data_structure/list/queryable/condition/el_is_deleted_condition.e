note
	description: "Condition is met if ${EL_STORABLE} item is deleted"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "4"

class
	EL_IS_DELETED_CONDITION [G -> EL_STORABLE]

inherit
	EL_QUERY_CONDITION [G]

feature -- Status query

	met (item: G): BOOLEAN
		-- True if condition is met for `item`
		do
			Result := item.is_deleted
		end
end