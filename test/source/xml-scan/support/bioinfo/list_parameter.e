note
	description: "List parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-24 15:05:50 GMT (Saturday 24th June 2023)"
	revision: "7"

deferred class
	LIST_PARAMETER [G]

inherit
	PARAMETER
		rename
			display_item as display_all_items
		undefine
			copy, is_equal
		redefine
			make, display_all_items, building_action_table
		end

	ARRAYED_LIST [G]
		rename
			make as make_list
		end

	EL_MODULE_LOG

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
			make_list (50)
		end

feature -- Basic operations

	display_all_items
			--
		do
			log.put_new_line
			from start until after loop
				display_item
				forth
			end
			log.put_new_line
		end

feature {NONE} -- Implementation

	display_item
		deferred
		end

feature {NONE} -- Build from XML

	extend_from_node
		deferred
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Nodes relative to element: value
		do
			create Result.make (<<
				[Text_node, agent extend_from_node]
			>>)
		end

end