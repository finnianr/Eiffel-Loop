note
	description: "Action to count the number of times an item in a list meets a condition"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 11:11:00 GMT (Wednesday 16th April 2025)"
	revision: "1"

class
	EL_COUNTING_ACTION [G]

inherit
	EL_CONTAINER_ACTION [G]

feature -- Access

	count: INTEGER

feature -- Basic operations

	do_with (item: G)
		do
			count := count + 1
		end

end