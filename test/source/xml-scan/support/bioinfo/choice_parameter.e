note
	description: "Choice parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "5"

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

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Nodes relative to element: value
		do
			create Result.make (<<
				["parlist", agent build_choice_list]
			>>)
		end
end