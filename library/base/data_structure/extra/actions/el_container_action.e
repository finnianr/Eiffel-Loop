note
	description: "Abstraction to perform some action for each item in a list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 11:56:50 GMT (Wednesday 16th April 2025)"
	revision: "1"

deferred class
	EL_CONTAINER_ACTION [G]

feature -- Basic operations

	do_if (item: G; condition: EL_QUERY_CONDITION [G])
		-- call `do_with' with `item' if `condition' is met
		do
			if condition.met (item) then
				do_with (item)
			end
		end

	do_with (item: G)
		deferred
		end

end