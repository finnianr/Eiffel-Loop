note
	description: "Summary description for {REAL_PARAMETER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-15 8:52:47 GMT (Tuesday 15th December 2015)"
	revision: "4"

class
	REAL_PARAMETER

inherit
	PARAMETER
		redefine
			 display_item, building_action_table
		end

create
	make

feature -- Basic operations

	display_item
			--
		do
			log.put_real_field (" value", item)
			log.put_new_line
		end

feature -- Access

	item: REAL

feature {NONE} -- Build from XML

	set_item_from_node
			--
		do
			item := node.to_real
		end

	building_action_table: like Type_building_actions
			-- Nodes relative to element: value
		do
			create Result.make (<<
				["text()", agent set_item_from_node]
			>>)
		end

end