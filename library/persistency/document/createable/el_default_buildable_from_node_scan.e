note
	description: "Default buildable from node scan"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_DEFAULT_BUILDABLE_FROM_NODE_SCAN

inherit
	EL_BUILDABLE_FROM_NODE_SCAN
		rename
			make_default as make
		end

create
	make

feature {NONE} -- Implementation

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result
		end

feature {NONE} -- Constants

	Parse_event_source_type: TYPE [EL_PARSE_EVENT_SOURCE]
		once
			Result := {EL_DEFAULT_PARSE_EVENT_SOURCE}
		end

	Root_node_name: STRING = ""
end