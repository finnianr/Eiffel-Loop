note
	description: "Eiffel source trees manifest"
	notes: "[
		Call **read_source_trees** to read all source tree file listings.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 17:09:44 GMT (Sunday 22nd September 2024)"
	revision: "33"

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
	make_default, make_from_file, make_from_string, make_from_directory

feature {NONE} -- Initialization

	make_default
			--
		do
			create source_tree_list.make (10)
			create last_name.make_empty
			create notes.make
			create notes_table.make (23)
			create name.make_empty
			Precursor
		end

	make_from_directory (a_dir_path: DIR_PATH)
		do
			make_default
			name.share (a_dir_path.to_string)
			source_tree_list.extend (create {SOURCE_TREE}.make (a_dir_path))
		end

	make_from_file (manifest_path: FILE_PATH)
		do
			parent_dir := manifest_path.parent
			Precursor (manifest_path)
			name.share (manifest_path.base_name)
		end

feature -- Access

	file_count: INTEGER

	file_list: EL_FILE_PATH_LIST
		require
			source_trees_read: source_trees_read
		do
			create Result.make (file_count)
			across source_tree_list as list loop
				Result.append_sequence (list.item.path_list)
			end
		end

	name: ZSTRING

	notes: LICENSE_NOTES
		-- default Eiffel source notes

	notes_table: EL_HASH_TABLE [LICENSE_NOTES, DIR_PATH]
		-- Eiffel source notes associated with `source_tree_list.item.dir_path'

	sorted_file_list: like file_list
		do
			Result := file_list
			Result.ascending_sort
		end

	sorted_locations: EL_SORTABLE_ARRAYED_LIST [SOURCE_TREE]
		do
			create Result.make_sorted (source_tree_list)
		end

	source_tree_list: EL_ARRAYED_LIST [SOURCE_TREE]

feature -- Status query

	source_trees_read: BOOLEAN
		do
			Result := file_count > 0
		end

feature -- Basic operations

	read_source_trees
		do
			across source_tree_list as list loop
				list.item.read_file_list
			end
			file_count := source_tree_list.sum_integer (agent {SOURCE_TREE}.file_count)
		end

feature {NONE} -- Build from Pyxis

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Nodes relative to root element: bix
		do
			create Result.make_assignments (<<
				["import/text()",	  agent import_manifest],
				["location/@name",  agent do node.set (last_name) end],
				["location/text()", agent extend_locations],
				["notes",			  agent do set_next_context (notes) end]
			>>)
		end

	extend_locations
			--
		local
			l_path: DIR_PATH; tree: SOURCE_TREE
		do
			l_path := node.to_expanded_dir_path
			if l_path.is_absolute then
				create tree.make (l_path)
			else
				create tree.make (parent_dir #+ l_path)
			end
			tree.set_name (last_name)
			source_tree_list.extend (tree)
			if not notes.is_empty then
				notes_table.extend (notes, tree.dir_path)
			end
		end

	import_manifest
		local
			file_path: FILE_PATH; other: SOURCE_MANIFEST
		do
			file_path := node.to_expanded_file_path
			if not file_path.is_absolute then
				file_path := parent_dir + file_path
			end
			if file_path.exists then
				create other.make_from_file (file_path)
				source_tree_list.append_sequence (other.source_tree_list)
			end
			-- Import notes if no notes specified in top level

			if notes.is_empty and then not other.notes.is_empty then
				notes := other.notes
			end
			notes_table.merge (other.notes_table)
		end

feature {NONE} -- Internal attributes

	last_name: ZSTRING

	parent_dir: DIR_PATH

feature {NONE} -- Constants

	Root_node_name: STRING = "manifest"

end