note
	description: "Recursive class. Attribute parameter_list may have other references to CONTAINER_PARAMETER"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:22 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	CONTAINER_PARAMETER

inherit
	PARAMETER
		redefine
			default_create, building_action_table, display_item
		end

create
	make

feature {NONE} -- Initialization

	default_create
			--
		do
			Precursor {PARAMETER}
			create parameter_list.make (10)
		end

feature -- Access

	parameter_list: PARAMETER_LIST

feature -- Basic operations

	display_item
			--
		do
			from parameter_list.start until parameter_list.after loop
				parameter_list.item.display
				parameter_list.forth
			end
		end

feature {NONE} -- Build from XML

	build_parameter_list
			--
		do
			set_next_context (parameter_list)
		end

	building_action_table: like Type_building_actions
			-- Nodes relative to element: value
		do
			create Result.make (<<
				["parlist", agent build_parameter_list]
			>>)
		end
end
