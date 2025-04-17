note
	description: "Container action to extend a ${SPECIAL} array"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 10:36:37 GMT (Wednesday 16th April 2025)"
	revision: "1"

class
	EL_EXTEND_SPECIAL_ACTION [G]

inherit
	EL_CONTAINER_ACTION [G]

create
	make

feature {NONE} -- Initialization

	make (a_area: like area)
		do
			area := a_area
		end

feature -- Basic operations

	do_with (item: G)
		do
			area.extend (item)
		end

feature {NONE} -- Internal attributes

	area: SPECIAL [G]
end