note
	description: "Recursive class. Attribute parameter_list may have other references to `CONTAINER_PARAMETER'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-24 14:26:14 GMT (Saturday 24th June 2023)"
	revision: "5"

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
			across parameter_list as list loop
				list.item.display
			end
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Nodes relative to element: value
		do
			create Result.make (<<
				["parlist", agent do set_next_context (parameter_list) end]
			>>)
		end
end