note
	description: "Parameter mapped to `text()' node"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 14:16:47 GMT (Sunday 22nd September 2024)"
	revision: "8"

deferred class
	TEXT_NODE_PARAMETER [G]

inherit
	PARAMETER
		undefine
			display_item
		redefine
			building_action_table
		end

feature -- Access

	item: G

feature {NONE} -- Build from XML

	set_item_from_node
		deferred
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Nodes relative to element: value
		do
			create Result.make_assignments (<<
				[Text_node, agent set_item_from_node]
			>>)
		end

end