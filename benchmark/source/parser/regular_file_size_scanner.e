note

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-04 12:14:07 GMT (Friday 4th October 2024)"
	revision: "14"

class
	REGULAR_FILE_SIZE_SCANNER

inherit
	EL_BUILDABLE_FROM_XML

	FILE_SIZE_SCANNER

	EL_XML_PARSE_EVENT_TYPE

create
	make

feature {NONE} -- Implementation

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Relative to root node: matrix
		do
			create Result.make_one ("entry/file-size/text()", agent increment_size_count)
		end

	Root_node_name: STRING = "rhythmdb"

end