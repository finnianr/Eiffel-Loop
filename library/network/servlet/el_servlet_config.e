note
	description: "Summary description for {EL_SERVLET_CONFIG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_SERVLET_CONFIG

inherit
	GOA_SERVLET_CONFIG
		rename
			document_root as document_root_utf8
		undefine
			default_create
		end

	EL_BUILDABLE_FROM_PYXIS
		redefine
			default_create, building_action_table, make_from_file
		end

	EL_MODULE_LOG
		undefine
			default_create
		end

create
	make_from_file

feature {NONE} -- Initialization

	default_create
			--
		do
			create document_root_utf8.make_empty
			server_port := Default_port
		end

	make_from_file (a_file_path: EL_FILE_PATH)
		do
			document_root_dir := a_file_path.parent
			Precursor (a_file_path)
			document_root_utf8 := document_root_dir.to_string.to_utf8
		end

feature -- Access

	document_root_dir: EL_DIR_PATH

feature -- Status query

	is_valid: BOOLEAN
		do
			Result := True
		end

feature {NONE} -- Build from XML

	building_action_table: like Type_building_actions
			-- Nodes relative to root element: bix
		do
			create Result.make (<<
				["@port", agent do server_port := node.to_integer end]
			>>)
		end

	Root_node_name: STRING = "config"

feature {NONE} -- Constants

	Default_port: INTEGER = 8000

end
