note
	description: "Summary description for {EL_EIFFEL_SOURCE_MANIFEST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-19 18:01:36 GMT (Friday 19th July 2013)"
	revision: "2"

class
	EIFFEL_SOURCE_MANIFEST

inherit
	EL_BUILDABLE_FROM_PYXIS
		redefine
			default_create, building_action_table
		end

	EL_MODULE_LOG
		undefine
			default_create
		end

create
	make_from_file, make_from_string

feature {NONE} -- Initialization

	default_create
			--
		do
			create file_list.make_empty
		end

feature -- Access

	file_list: EL_FILE_PATH_LIST

feature {NONE} -- Build from XML

	append_files
			--
		local
			dir_path_steps: EL_PATH_STEPS
		do
			dir_path_steps := node.to_string
			dir_path_steps.expand_variables
			file_list.append_files (dir_path_steps, "*.e")
		end

	building_action_table: like Type_building_actions
			-- Nodes relative to root element: bix
		do
			create Result.make (<<
				["locations/text()", agent append_files]
			>>)
		end

	Root_node_name: STRING = "manifest"

end
