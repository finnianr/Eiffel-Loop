note
	description: "Source manifest"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-17 10:06:31 GMT (Tuesday 17th August 2021)"
	revision: "12"

class
	SOURCE_MANIFEST

inherit
	EL_BUILDABLE_FROM_PYXIS
		redefine
			make_default, make_from_file, building_action_table
		end

	EL_MODULE_LIO

	EL_ZSTRING_CONSTANTS

create
	make_default, make_from_file, make_from_string

feature {NONE} -- Initialization

	make_default
			--
		do
			create source_tree_list.make (10)
			create last_name.make_empty
			Precursor
		end

	make_from_file (a_file_path: EL_FILE_PATH)
		do
			parent_dir := a_file_path.parent
			Precursor (a_file_path)
		end

feature -- Access

	file_list: EL_FILE_PATH_LIST
		do
			create Result.make_with_count (source_tree_list.sum_integer (agent {SOURCE_TREE}.file_count))
			across source_tree_list as list loop
				Result.append_sequence (list.item.path_list)
			end
		end

	source_tree_list: EL_ARRAYED_LIST [SOURCE_TREE]

	sorted_file_list: like file_list
		do
			Result := file_list
			Result.sort
		end

	sorted_locations: EL_SORTABLE_ARRAYED_LIST [SOURCE_TREE]
		do
			create Result.make_sorted (source_tree_list)
		end

feature {NONE} -- Build from Pyxis

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Nodes relative to root element: bix
		do
			create Result.make (<<
				["location/@name", agent do last_name := node.to_string end],
				["location/text()", agent extend_locations]
			>>)
		end

	extend_locations
			--
		local
			l_path: EL_DIR_PATH; tree: SOURCE_TREE
		do
			l_path := node.to_expanded_dir_path
			if l_path.is_absolute then
				create tree.make (l_path)
			else
				create tree.make (parent_dir.joined_dir_path (l_path))
			end
			tree.set_name (last_name)
			source_tree_list.extend (tree)
		end

feature {NONE} -- Internal attributes

	parent_dir: EL_DIR_PATH

	last_name: ZSTRING

feature {NONE} -- Constants

	Root_node_name: STRING = "manifest"

end