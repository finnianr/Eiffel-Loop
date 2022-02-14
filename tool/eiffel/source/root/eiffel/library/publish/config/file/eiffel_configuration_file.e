note
	description: "Eiffel project configuration file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-14 12:27:43 GMT (Monday 14th February 2022)"
	revision: "41"

class
	EIFFEL_CONFIGURATION_FILE

inherit
	SOURCE_TREE
		rename
			make as make_tree,
			file_count as source_file_count
		redefine
			getter_function_table, make_default, new_path_list
		end

	EL_FILE_OPEN_ROUTINES

	EL_MODULE_LIO

	EL_MODULE_DIRECTORY

	EL_MODULE_TUPLE

	EL_STRING_8_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_repository: like repository; ecf: ECF_INFO; root: EL_XPATH_ROOT_NODE_CONTEXT)
			--
		require
			parse_ok: not root.parse_failed
		do
			make_default
			repository := a_repository
			relative_ecf_path.share (ecf.path)
			type_qualifier := ecf.type_qualifier
			html_index_path := ecf.html_index_path
			ecf_dir := ecf_path.parent
			across root.context_list (Xpath_mapping) as map loop
				extend_alias_table (map.node.attributes)
			end
			source_dir_list := new_source_dir_list (root.context_list (ecf.cluster_xpath), ecf_dir)
			across source_dir_list as path loop
				if path.cursor_index = 1 then
					dir_path := path.item
				elseif not dir_path.is_parent_of (path.item) then
					dir_path := path.item.parent
				end
			end
			path_list := new_path_list; sub_category := new_sub_category
			set_name_and_description (ecf.description (root))
			set_directory_list (a_repository.parser)
			a_repository.parser.update (False)
		end

	make_default
		do
			alias_table := Default_alias_table
			type_qualifier := Empty_string_8
			create source_dir_list.make (0)
			create directory_list.make_empty
			create description_lines.make_empty
			create ecf_dir
			create relative_ecf_path
			create sub_category.make_empty
			Precursor
		end

feature -- Access

	alias_table: like Default_alias_table
		-- map class alias to actual name

	category: ZSTRING
		do
			Result := relative_dir_path.first_step.as_proper_case
		end

	category_index_title: ZSTRING
		-- Category title for sitemap index
		do
			if category.is_empty then
				Result := category
			elseif category [category.count] = 'y' then
				Result := category.substring (1, category.count - 1) + Y_plural
			else
				Result := category + character_string ('s')
			end
		end

	category_title: ZSTRING
		-- displayed category title
		do
			if sub_category.is_empty then
				Result := category
			else
				Result := sub_category + character_string (' ') + category
			end
		end

	class_count: INTEGER
		do
			across directory_list as source_dir loop
				Result := Result + source_dir.item.class_list.count
			end
		end

	description_lines: EL_ZSTRING_LIST

	directory_list: EL_ARRAYED_LIST [SOURCE_DIRECTORY]

	ecf_dir: DIR_PATH

	ecf_name: ZSTRING
		do
			Result := relative_ecf_path.base
		end

	ecf_path: FILE_PATH
		do
			Result := repository.root_dir + relative_ecf_path
		end

	html_index_path: FILE_PATH
		-- relative path to html index for ECF, and qualified with cluster name when specified in config.pyx

	relative_dir_path: DIR_PATH
		do
			Result := dir_path.relative_path (repository.root_dir)
		end

	relative_ecf_path: FILE_PATH

	source_dir_list: like new_source_dir_list

	sub_category: ZSTRING

	type: STRING
		do
			Result := once "project" + type_qualifier
		end

	type_qualifier: STRING

feature -- Element change

	set_name_and_description (a_description: ZSTRING)
		-- set `name' from first line of `a_description' and `description_lines' from the remainder
		-- if `a_description' contains some text "See <file_path> for details", then set `description_lines'
		-- from text in referenced file path
		local
			doc_path, relative_doc_path: FILE_PATH
			lines: like description_lines
		do
			create lines.make_with_lines (a_description)
			from lines.start until lines.after loop
				if lines.index = 1 then
					name := lines.item
				elseif lines.item.starts_with (See_details.begins) and then lines.item.has_substring (See_details.ends) then
					relative_doc_path := lines.item.substring_between (See_details.begins, See_details.ends, 1)
					doc_path := ecf_dir + relative_doc_path
					if attached open_lines (doc_path, Utf_8) as file_lines then
						file_lines.do_all (agent description_lines.extend)
						file_lines.close
					else
						description_lines.extend (lines.item + " (Missing file?)")
					end
				else
					description_lines.extend (lines.item)
				end
				lines.forth
			end
		end

feature -- Basic operations

	read_source_files (parser: EIFFEL_CLASS_PARSER)
		local
			parent_dir: DIR_PATH; directory_group: SOURCE_DIRECTORY
			source_path: FILE_PATH
		do
			lio.put_labeled_string ("Reading classes", html_index_path)
			lio.put_new_line
			create parent_dir; create source_path

			directory_list.wipe_out
			across sorted_path_list as path loop
				if source_path ~ path.item then
					lio.put_labeled_string ("Duplicate", source_path.base)
					lio.put_new_line
				end
				source_path := path.item
				if source_path.parent /~ parent_dir then
					create directory_group.make (Current, directory_list.count + 1)
					directory_list.extend (directory_group)
					parent_dir := source_path.parent
				end
				lio.put_character ('.')
				if path.cursor_index \\ 80 = 0 or path.is_last then
					lio.put_new_line
				end
				parser.queue (Current, directory_group, source_path)
			end
		end

feature -- Factory

	new_class (source_path: FILE_PATH): EIFFEL_CLASS
		do
			create Result.make (source_path, Current, repository)
		end

	new_path_list: EL_FILE_PATH_LIST
		local
			list: EL_FILE_PATH_LIST
		do
			across source_dir_list as path loop
				if path.cursor_index = 1 then
					Result := OS.file_list (path.item, Symbol.star_dot_e)
				else
					list := OS.file_list (path.item, Symbol.star_dot_e)
					Result.append (list)
				end
			end
		end

	new_sort_category: ZSTRING
		do
			Result := category
		end

	new_source_dir_list (cluster_nodes: EL_XPATH_NODE_CONTEXT_LIST; parent_dir: DIR_PATH): EL_ARRAYED_LIST [DIR_PATH]
		local
			source_dir: DIR_PATH; location: ZSTRING; is_recursive: BOOLEAN
			sub_cluster_nodes: EL_XPATH_NODE_CONTEXT_LIST
		do
			create Result.make (cluster_nodes.count)
			across cluster_nodes as cluster loop
				location := cluster.node.attributes [Attribute_location]
				if cluster.node.attributes.has (Attribute_recursive) then
					is_recursive := cluster.node.attributes.boolean (Attribute_recursive)
				end
				if location.starts_with (Symbol.parent_dir) then
					source_dir := parent_dir.parent #+ location.substring_end (4)
				elseif location.starts_with (Symbol.relative_location) then
					location.remove_head (Symbol.relative_location.count)
					source_dir := parent_dir #+ location
				else
					source_dir := parent_dir #+ location
				end
				if is_recursive then
					Result.extend (source_dir)
				else
					sub_cluster_nodes := cluster.node.context_list (Element_cluster)
					if sub_cluster_nodes.count = 0 then
						Result.extend (source_dir)
					else
						-- Recursive call
						Result.append (new_source_dir_list (sub_cluster_nodes, source_dir))
					end
				end
			end
		end

	new_sub_category: ZSTRING
		do
			create Result.make_empty
		end

feature {NONE} -- Implementation

	extend_alias_table (map: EL_ELEMENT_ATTRIBUTE_TABLE)
		do
			if alias_table = Default_alias_table then
				create alias_table.make_equal (2)
			end
			alias_table [map [Mapping.old_name]] := map [Mapping.new_name]
		end

	set_directory_list (parser: EIFFEL_CLASS_PARSER)
		local
			group_table: EL_FUNCTION_GROUP_TABLE [FILE_PATH, DIR_PATH]
			directory_group: SOURCE_DIRECTORY; file_count: INTEGER
		do
			lio.put_labeled_string ("Reading classes", html_index_path)
			lio.put_new_line
			create group_table.make_from_list (agent {FILE_PATH}.parent, sorted_path_list)
			create directory_list.make (group_table.count)

			across group_table as group loop
				create directory_group.make (Current, group.item.count)
				directory_list.extend (directory_group)
				file_count := file_count + 1
				across group.item as path loop
					lio.put_character ('.')
					if file_count \\ 80 = 0 or (directory_list.full and then path.is_last) then
						lio.put_new_line
					end
					parser.queue (Current, directory_group, path.item)
				end
			end
		end

feature {NONE} -- Implementation attributes

	repository: REPOSITORY_PUBLISHER

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor +
				["directory_list",		agent: like directory_list do Result := directory_list end] +
				["has_description",		agent: BOOLEAN_REF do Result := (not description_lines.is_empty).to_reference end] +
				["github_description",	agent: ZSTRING do Result := Translater.to_github_markdown (description_lines) end]
		end

feature {NONE} -- Xpath constants

	Attribute_location: STRING = "location"

	Attribute_recursive: STRING = "recursive"

	Element_cluster: STRING = "cluster"

feature {NONE} -- Constants

	Default_alias_table: EL_ZSTRING_HASH_TABLE [ZSTRING]
		once
			create Result.make_equal (0)
		end

	Symbol: TUPLE [dot, star_dot_e, parent_dir, relative_location: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "., *.e, ../, $|")
		end

	Library: ZSTRING
		once
			Result := "library"
		end

	Mapping: TUPLE [old_name, new_name: STRING]
		once
			create Result
			Tuple.fill (Result, "old_name, new_name")
		end

	See_details: TUPLE [begins, ends: ZSTRING]
		once
			create Result
			Result.begins := "See "
			Result.ends := " for details"
		end

	Translater: MARKDOWN_TRANSLATER
		once
			create Result.make (repository.web_address)
		end

	Y_plural: ZSTRING
		once
			Result := "ies"
		end

	Xpath_mapping: STRING = "/system/target/mapping"

end