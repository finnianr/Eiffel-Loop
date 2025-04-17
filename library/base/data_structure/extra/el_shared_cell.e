note
	description: "Shared cell"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-20 19:56:04 GMT (Wednesday 20th December 2023)"
	revision: "8"

deferred class
	EL_SHARED_CELL [G]

inherit
	EL_ANY_SHARED

feature -- Access

	item: G
		do
			Result := cell.item
		end

feature -- Element change

	set_item (a_item: like item)
		do
			cell.put (a_item)
		end

feature {NONE} -- Implementation

	cell: CELL [G]
		deferred
		end

end