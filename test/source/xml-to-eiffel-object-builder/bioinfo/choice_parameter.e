note
	description: "Summary description for {CHOICE_PARAMETER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:22 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	CHOICE_PARAMETER

inherit
	CONTAINER_PARAMETER
		rename
			parameter_list as choice_list,
			build_parameter_list as build_choice_list
		redefine
			building_action_table
		end

create
	make

feature {NONE} -- Build from XML

	building_action_table: like Type_building_actions
			-- Nodes relative to element: value
		do
			create Result.make (<<
				["parlist", agent build_choice_list]
			>>)
		end
end
