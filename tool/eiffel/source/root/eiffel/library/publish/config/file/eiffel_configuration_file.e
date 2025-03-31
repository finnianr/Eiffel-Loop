note
	description: "Eiffel project configuration file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-31 8:03:19 GMT (Monday 31st March 2025)"
	revision: "72"

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

	EL_MODULE_DIRECTORY; EL_MODULE_LIO

	ECF_CONSTANTS; EL_CHARACTER_32_CONSTANTS

	PUBLISHER_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_config: like config; ecf: ECF_INFO; root: EL_XML_DOC_CONTEXT)
			--
		require
			parse_ok: not root.parse_failed
		do
			make_default
			config := a_config
			relative_ecf_path.share (ecf.path)
			type_qualifier := ecf.type_qualifier
			html_index_path := ecf.html_index_path
			ecf_dir := ecf_path.parent
			across root.context_list (Xpath_mapping) as map loop
				extend_alias_table (map.node)
			end
			if attached new_source_dir_map_list (root.context_list (ecf.cluster_xpath), ecf_dir) as list then
				source_dir_list.grow (list.count)
				excluded_dir_table.accommodate (list.count)
				from list.start until list.after loop
					if attached list.item_key as source_dir then
						source_dir_list.extend (source_dir)
						if list.item_value.count > 0 then
							excluded_dir_table.extend (list.item_value, source_dir)
						end
					end
					list.forth
				end
			end
			across source_dir_list as path loop
				if path.is_first then
					dir_path := path.item
				elseif not dir_path.is_parent_of (path.item) then
					dir_path := path.item.parent
				end
			end
			path_list := new_path_list; sub_category := new_sub_category
			set_name_and_description (ecf.description (root))
		end

	make_default
		do
			alias_table := Default_alias_table
			type_qualifier := Empty_string_8
			create excluded_dir_table
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

	category_and_name: ZSTRING
		-- joined category and name
		do
			Result := space.joined (category, name)
		end

	category_index_title: ZSTRING
		-- Category title for sitemap index
		local
			s: EL_ZSTRING_ROUTINES
		do
			if category.is_empty then
				Result := category
			elseif category [category.count] = 'y' then
				Result := category.substring (1, category.count - 1) + Y_plural
			else
				Result := category + s.character_string ('s')
			end
		end

	category_title: ZSTRING
		-- displayed category title
		do
			Result := if sub_category.is_empty then category else space.joined (sub_category, category) end
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
			Result := config.root_dir.plus_file (relative_ecf_path)
		end

	html_index_path: FILE_PATH
		-- relative path to html index for ECF, and qualified with cluster name when specified in config.pyx

	relative_dir_path: DIR_PATH
		do
			Result := dir_path.relative_path (config.root_dir)
		end

	relative_ecf_path: FILE_PATH

	source_dir_list: EL_ARRAYED_LIST [DIR_PATH]

	sorted_class_list: EL_ARRAYED_LIST [EIFFEL_CLASS]
		do
			create Result.make (directory_list.sum_integer (agent {SOURCE_DIRECTORY}.count))
			across directory_list as dir loop
				across dir.item.class_list as list loop
					Result.extend (list.item)
				end
			end
			Result.order_by (agent {EIFFEL_CLASS}.relative_source_path, True)
		end

	sub_category: ZSTRING

	type: STRING
		do
			Result := once "project" + type_qualifier
		end

	type_qualifier: STRING

feature -- Element change

	add_new_classes (group_table: like new_directory_group_table)
		local
			source_directory: SOURCE_DIRECTORY
		do
			across group_table as table loop
				directory_list.find_first_equal (table.key, agent {SOURCE_DIRECTORY}.dir_path)
				if directory_list.found then
					source_directory := directory_list.item
				else
					create source_directory.make (Current, directory_list.count + 1)
					directory_list.extend (source_directory)
				end
				across table.item as path loop
					lio.put_character ('.')
					add_class (source_directory, new_class (path.item))
				end
			end
		end

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
				elseif lines.item.starts_with (See_details.begins)
					and then lines.item.has_substring (See_details.ends)
				then
					relative_doc_path := lines.item.substring_between (See_details.begins, See_details.ends, 1)
					doc_path := ecf_dir.plus_file (relative_doc_path)
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

	read_class_source (parser: EIFFEL_CLASS_PARSER)
		local
			group_table: EL_FUNCTION_GROUPED_SET_TABLE [FILE_PATH, DIR_PATH]
			source_directory: SOURCE_DIRECTORY; file_count: INTEGER
		do
			lio.put_labeled_string ("Reading classes", html_index_path)
			lio.put_new_line
			create group_table.make_equal_from_list (agent {FILE_PATH}.parent, sorted_path_list)
			create directory_list.make (group_table.count)

			across group_table as group loop
				create source_directory.make (Current, group.item.count)
				directory_list.extend (source_directory)
				file_count := file_count + 1
				across group.item as path loop
					lio.put_character ('.')
					if file_count \\ 80 = 0 or (directory_list.full and then path.is_last) then
						lio.put_new_line
					end
					parser.queue (agent add_class (source_directory, ?), path.item)
				end
				parser.apply
			end
			Class_table.append_alias (alias_table)
		end

	update_source_files (update_checker: EIFFEL_CLASS_UPDATE_CHECKER)
		-- Fast check of files that have been modified
		local
			group_table: like new_directory_group_table
			source_dir: DIR_PATH; new_source_set: EL_ARRAYED_LIST [FILE_PATH]
			e_class: EIFFEL_CLASS; file_count: INTEGER
		do
			path_list := new_path_list; group_table := new_directory_group_table
			lio.put_labeled_string ("Checking classes", html_index_path)
			lio.put_new_line

			-- remove existing classes from `group_table'
			across directory_list as list loop
				if attached list.item.class_list as class_list and then class_list.count > 0 then
					source_dir := list.item.dir_path
					group_table.search (source_dir)
					if group_table.found then
						new_source_set := group_table.found_set
					else
						create new_source_set.make_empty
					end
					new_source_set.compare_objects

					from class_list.start until class_list.after loop
						file_count := file_count + 1
						e_class := class_list.item
						new_source_set.start; new_source_set.search (e_class.source_path)
						if new_source_set.found then
							update_checker.queue (agent update_class (class_list, class_list.item))
							new_source_set.remove
							class_list.forth
						else
							Class_table.remove (e_class.name)
							Class_link_list.remove_class (e_class)
							class_list.remove
						end
						if file_count \\ 80 = 0 or (list.is_last and class_list.islast) then
							lio.put_new_line
						end
					end
					if group_table.found and then new_source_set.is_empty then
						group_table.remove (source_dir)
					end
					update_checker.apply
				end
			end
			directory_list.prune_those (agent {SOURCE_DIRECTORY}.is_empty)

			add_new_classes (group_table)
		end

feature -- Factory

	new_class (source_path: FILE_PATH): EIFFEL_CLASS
		do
			create Result.make (source_path, Current, config)
		end

	new_directory_group_table: EL_FUNCTION_GROUPED_SET_TABLE [FILE_PATH, DIR_PATH]
		do
			create Result.make_equal_from_list (agent {FILE_PATH}.parent, sorted_path_list)
		end

	new_path_list: EL_FILE_PATH_LIST
		local
			file_list: EL_FILE_PATH_LIST; not_excluded: EL_PREDICATE_QUERY_CONDITION [FILE_PATH]
		do
			across source_dir_list as path loop
				if excluded_dir_table.has_key (path.item) then
					not_excluded := agent not_excluded_path (excluded_dir_table.found_item, ?)
					create file_list.make_from_list (OS.file_list (path.item, Symbol.star_dot_e).query (not_excluded))
				else
					file_list := OS.file_list (path.item, Symbol.star_dot_e)
				end
				if path.cursor_index = 1 then
					Result := file_list
				else
					Result.append (file_list)
				end
			end
		end

	new_sort_category: ZSTRING
		do
			Result := category
		end

	new_source_dir_map_list (
		cluster_nodes: EL_XPATH_NODE_CONTEXT_LIST; parent_dir: DIR_PATH
	): EL_ARRAYED_MAP_LIST [DIR_PATH, like Empty_dir_list]
		-- map source directory path to excluded step list from file_rule like:

		-- file_rule:
		--		exclude:
		-- 		"/file$"
		--			"/io$"

		-- (but ignoring exclusions with platform conditions)

		local
			source_dir: DIR_PATH; location: ZSTRING; is_recursive: BOOLEAN
			sub_cluster_nodes: EL_XPATH_NODE_CONTEXT_LIST
		do
			create Result.make (cluster_nodes.count)
			across cluster_nodes as cluster loop
				location := cluster.node [Attribute_location]
				if cluster.node.has_attribute (Attribute_recursive) then
					is_recursive := cluster.node [Attribute_recursive]
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
					Result.extend (source_dir, new_excluded_dir_list (cluster.node, source_dir))
				else
					sub_cluster_nodes := cluster.node.context_list (Element_cluster)
					if sub_cluster_nodes.count = 0 then
						Result.extend (source_dir, Empty_dir_list)
					else
						-- Recursive call
						across new_source_dir_map_list (sub_cluster_nodes, source_dir) as list loop
							Result.extend (list.key, list.value)
						end
					end
				end
			end
		end

	new_excluded_dir_list (cluster: EL_XPATH_NODE_CONTEXT; source_dir: DIR_PATH): like Empty_dir_list
		do
			Result := Empty_dir_list
			across cluster.context_list (Xpath_file_exclude) as file_rule loop
				if attached file_rule.node.as_string as step then
					if step.starts_with_character ('/') and then step.ends_with_character ('$')
						and then not step.ends_with_general (once ".e$")
					then
						step.remove_ends
						Result.extend (source_dir #+ step)
					end
				end
			end
			if Result.count > 0 then
				Result := Result.twin
				Empty_dir_list.wipe_out
			end
		ensure
			always_empty: Empty_dir_list.is_empty
		end

	new_sub_category: ZSTRING
		do
			create Result.make_empty
		end

feature {NONE} -- Implementation

	add_class (source_directory: SOURCE_DIRECTORY; e_class: EIFFEL_CLASS)
		do
			Class_table.put_class (e_class)
			source_directory.class_list.extend (e_class)
		end

	extend_alias_table (map_node: EL_XPATH_NODE_CONTEXT)
		do
			if alias_table = Default_alias_table then
				create alias_table.make_equal (2)
			end
			alias_table [map_node [Mapping.old_name]] := map_node [Mapping.new_name]
		end

	not_excluded_path (excluded_dir_list: like Empty_dir_list; source_path: FILE_PATH): BOOLEAN
		do
			Result := across excluded_dir_list as list all
				not list.item.is_parent_of (source_path)
			end
		end

	update_class (class_list: EL_ARRAYED_LIST [EIFFEL_CLASS]; e_class: EIFFEL_CLASS)
		do
			class_list.start; class_list.search (e_class)
			if class_list.found then
				class_list.replace (new_class (e_class.source_path))
				Class_link_list.replace_class (e_class, class_list.item)
			end
		end

feature {NONE} -- Implementation attributes

	config: PUBLISHER_CONFIGURATION

	excluded_dir_table: EL_HASH_TABLE [like Empty_dir_list, DIR_PATH]

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor +
				["directory_list",		agent: like directory_list do Result := directory_list end] +
				["has_description",		agent: BOOLEAN_REF do Result := (not description_lines.is_empty).to_reference end] +
				["github_description",	agent: ZSTRING do Result := Translater.to_github_markdown (description_lines) end]
		end

feature {NONE} -- Constants

	Empty_dir_list: ARRAYED_LIST [DIR_PATH]
		once ("PROCESS")
			create Result.make (0)
		end

	Xpath_file_exclude: STRING = "file_rule [count (condition) = 0]/exclude"
		-- file rule excluding platform condition

	Translater: MARKDOWN_TRANSLATER
		once
			create Result.make (config)
		end

end