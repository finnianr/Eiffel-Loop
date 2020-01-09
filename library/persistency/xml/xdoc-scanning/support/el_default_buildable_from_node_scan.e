note
	description: "Default buildable from node scan"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-09 17:14:56 GMT (Thursday 9th January 2020)"
	revision: "1"

class
	EL_DEFAULT_BUILDABLE_FROM_NODE_SCAN

inherit
	EL_BUILDABLE_FROM_NODE_SCAN
		rename
			make_default as make
		end

	EL_XML_PARSE_EVENT_TYPE

create
	make

feature {NONE} -- Implementation

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result
		end

	Root_node_name: STRING = ""
end
