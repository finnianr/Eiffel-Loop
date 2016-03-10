note
	description: "Amazon exercise in linked list reversal"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:34 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	NODE_LINK [G]

create
	make

feature {NONE} -- Initialization

	make (v: like item)
			--
		do
			item := v
		end

feature -- Element change

	set_right (node: like right)
			-- set right neighbour
		do
			right := node
			has_right := True
		end

feature -- Status query

	has_right: BOOLEAN
		-- has node to right

feature -- Access

	item: G

	right: like Current

end
