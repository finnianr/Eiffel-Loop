note
	description: "Summary description for {BOOLEAN_PARAMETER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:31 GMT (Tuesday 2nd September 2014)"
	revision: "2"

class
	BOOLEAN_PARAMETER

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
			log.put_string ("value: ")
			log.put_boolean (item)
			log.put_new_line
		end

feature -- Access

	item: BOOLEAN

feature {NONE} -- Build from XML

	set_item_from_node
			--
		do
			item := node.to_boolean
		end

	building_action_table: like Type_building_actions
			-- Nodes relative to element: value
		do
			create Result.make (<<
				["text()", agent set_item_from_node]
			>>)
		end

end
