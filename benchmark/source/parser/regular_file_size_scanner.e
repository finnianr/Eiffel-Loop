note
	description: "[
		Find sum of all `file-size' counts in rhythmdb.xml using regular xpath processing
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-27 7:13:08 GMT (Thursday 27th July 2023)"
	revision: "12"

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
			create Result.make (<<
				["entry/file-size/text()", agent increment_size_count]
			>>)
		end

	Root_node_name: STRING = "rhythmdb"

end