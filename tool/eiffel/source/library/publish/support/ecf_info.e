note
	description: "Eiffel library configuration ino"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-17 13:47:15 GMT (Wednesday 17th October 2018)"
	revision: "2"

class
	ECF_INFO

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make
		redefine
			make
		end

	EL_ZSTRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			cluster := Empty_string
			description := Empty_string
			create path
			Precursor
		end

feature -- Access

	cluster: ZSTRING

	description: ZSTRING

	path: EL_FILE_PATH

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE
		do
			create Result.make (<<
				["@cluster", 	agent do cluster := node.to_string end],
				["description/text()", 	agent do description := node.to_string end],
				["text()", agent do path.set_path (node.to_string) end]
			>>)
		end
end
