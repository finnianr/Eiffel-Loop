note
	description: "Summary description for {CHOICE_PARAMETER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:44 GMT (Thursday 11th December 2014)"
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

	building_action_table: EL_PROCEDURE_TABLE
			-- Nodes relative to element: value
		do
			create Result.make (<<
				["parlist", agent build_choice_list]
			>>)
		end
end
