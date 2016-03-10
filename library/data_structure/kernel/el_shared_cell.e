note
	description: "Summary description for {EL_SHARED_CELL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
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
