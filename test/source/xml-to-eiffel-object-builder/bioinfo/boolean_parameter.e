note
	description: "Summary description for {BOOLEAN_PARAMETER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-15 8:51:20 GMT (Tuesday 15th December 2015)"
	revision: "1"

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
			log.put_labeled_string (" value", item.out)
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

	building_action_table: EL_PROCEDURE_TABLE
			-- Nodes relative to element: value
		do
			create Result.make (<<
				["text()", agent set_item_from_node]
			>>)
		end

end
