note
	description: "Recursive class. Attribute parameter_list may have other references to `CONTAINER_PARAMETER'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-07 16:21:20 GMT (Thursday 7th July 2016)"
	revision: "4"

class
	CONTAINER_PARAMETER

inherit
	PARAMETER
		redefine
			make, building_action_table, display_item
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
			create parameter_list.make (10)
		end

feature -- Access

	parameter_list: PARAMETER_LIST

feature -- Basic operations

	display_item
			--
		do
			log.put_new_line
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
