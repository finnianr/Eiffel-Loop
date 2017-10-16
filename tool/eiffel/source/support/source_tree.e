note
	description: "Summary description for {EIFFEL_SOURCE_LOCATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-13 9:51:50 GMT (Friday 13th October 2017)"
	revision: "5"

class
	SOURCE_TREE

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
	make

feature {NONE} -- Initialization

	make (a_dir_path: like dir_path)
		do
			make_default
			dir_path := a_dir_path
		end

	make_default
			--
		do
			create name.make_empty
			create dir_path
			Precursor {EVOLICITY_EIFFEL_CONTEXT}
			Precursor {EL_EIF_OBJ_BUILDER_CONTEXT}
		end

feature -- Access

	dir_path: EL_DIR_PATH

	name: ZSTRING

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

	set_dir_path_from_node
		local
			l_path: EL_DIR_PATH
		do
			l_path := node.to_expanded_dir_path
			if l_path.is_absolute then
				dir_path := l_path
			else
				dir_path := dir_path.joined_dir_path (l_path)
			end
		end

	building_action_table: EL_PROCEDURE_TABLE
		do
			create Result.make (<<
				["@name", agent do name := node.to_string end],
				[Xpath_dir_path, agent set_dir_path_from_node]
			>>)
		end

feature {NONE} -- Constants

	Xpath_dir_path: STRING
		once
			Result := "text()"
		end
end
