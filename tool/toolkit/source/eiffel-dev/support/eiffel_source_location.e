note
	description: "Summary description for {EIFFEL_SOURCE_LOCATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EIFFEL_SOURCE_LOCATION

inherit
	EVOLICITY_EIFFEL_CONTEXT
		rename
			make_default as make
		undefine
			is_equal
		redefine
			make
		end

	EL_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make
		undefine
			is_equal
		redefine
			make
		end

	COMPARABLE

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create file_list.make_empty
			create name.make_empty
			Precursor {EVOLICITY_EIFFEL_CONTEXT}
			Precursor {EL_EIF_OBJ_BUILDER_CONTEXT}
		end

feature -- Access

	name: ASTRING

	file_list: EL_FILE_PATH_LIST

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			Result := name < other.name
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["name", 			agent: like name do Result := name end],
				["file_list", 		agent: like file_list do Result := file_list end]
			>>)
		end

feature {NONE} -- Build from Pyxis

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
				["@name", agent do name := node.to_string end],
				["text()", agent append_files]
			>>)
		end
end
