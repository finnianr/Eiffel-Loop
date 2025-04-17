note
	description: "Action to find maxiumum value for a list of ${NUMERIC} values"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 10:46:00 GMT (Wednesday 16th April 2025)"
	revision: "1"

class
	EL_NUMERIC_MAXIMUM_ACTION [G, N -> NUMERIC]

inherit
	EL_NUMERIC_ACTION [G, N]

create
	make

feature {NONE} -- Initialization

	initialize
		do
			number.set_to_min_value
		end

feature -- Basic operations

	do_with (item: G)
		do
			number.set_max (new_value (item))
		end

end