note
	description: "Summary description for {EIFFEL_SOURCE_LOCATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-06 12:41:46 GMT (Wednesday 6th July 2016)"
	revision: "8"

class
	EIFFEL_SOURCE_TREE

inherit
	EVOLICITY_EIFFEL_CONTEXT
		undefine
			is_equal
		redefine
			make_default
		end

	EL_EIF_OBJ_BUILDER_CONTEXT
		undefine
			is_equal
		redefine
			make_default
		end

	COMPARABLE

create
	make_default

feature {NONE} -- Initialization

	make_default
			--
		do
			create name.make_empty
			create dir_path
			Precursor {EVOLICITY_EIFFEL_CONTEXT}
			Precursor {EL_EIF_OBJ_BUILDER_CONTEXT}
		end

feature -- Access

	name: ZSTRING

	dir_path: EL_DIR_PATH

	path_list: EL_FILE_PATH_LIST
		do
			create Result.make (dir_path, "*.e")
		end

	sorted_path_list: EL_FILE_PATH_LIST
		do
			Result := path_list
			Result.sort
		end

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
				["path_list", 		agent: like path_list do Result := path_list end]
			>>)
		end

feature {NONE} -- Build from Pyxis

	building_action_table: like Type_building_actions
		do
			create Result.make (<<
				["@name", agent do name := node.to_string end],
				["text()", agent do dir_path := node.to_expanded_dir_path end]
			>>)
		end
end
