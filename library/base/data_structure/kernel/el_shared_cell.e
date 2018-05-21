note
	description: "Shared cell"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "3"

deferred class
	EL_SHARED_CELL [G]

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