note
	description: "Eiffel configuration file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-05 19:04:45 GMT (Sunday 5th April 2020)"
	revision: "26"

class
	EIFFEL_CONFIGURATION_FILE

inherit
	SOURCE_TREE
		rename
			make as make_tree
		redefine
			getter_function_table, make_default, new_path_list
		end

	EL_MODULE_LOG

	EL_MODULE_DIRECTORY

create
	make

feature {NONE} -- Initialization

	make (a_repository: like repository; ecf: ECF_INFO)
			--
		local
			root: EL_XPATH_ROOT_NODE_CONTEXT; l_description: ZSTRING
		do
			make_default
			repository := a_repository
			relative_ecf_path.share (ecf.path)

			html_index_path := relative_ecf_path.without_extension
			if attached {ECF_CLUSTER_INFO} ecf as cluster then
				html_index_path.add_extension (cluster.name)
				is_cluster := True
			end
			html_index_path.add_extension (Html)

			ecf_dir := ecf_path.parent
			create root.make_from_file (a_repository.root_dir + relative_ecf_path)
			if root.parse_failed then
				lio.put_path_field ("Parse failed", relative_ecf_path)
				lio.put_new_line
			else
				is_library := root.is_xpath (Xpath_all_classes)
				source_dir_list := new_source_dir_list (root.context_list (ecf.cluster_xpath), ecf_dir)
				across source_dir_list as path loop
					if path.cursor_index = 1 then
						dir_path := path.item
					elseif not dir_path.is_parent_of (path.item) then
						dir_path := path.item.parent
					end
				end
				path_list := new_path_list; sub_category := new_sub_category
				l_description := root.string_at_xpath (ecf.description_xpath).stripped
				if is_cluster and l_description.is_empty then
					l_description := ecf.description
				end
				set_name_and_description (l_description)
			end
			set_directory_list (a_repository.parser)
			a_repository.parser.update (False)
		end

	make_default
		do
			create source_dir_list.make (0)
			create directory_list.make_empty
			create description_lines.make_empty
			create ecf_dir
			create relative_ecf_path
			create sub_category.make_empty
			Precursor
		end

feature -- Access

	category: ZSTRING
		do
			Result := relative_dir_path.first_step.as_proper_case
		end

	class_count: INTEGER
		do
			across directory_list as source_dir loop
				Result := Result + source_dir.item.class_list.count
			end
		end

	description_lines: EL_ZSTRING_LIST

	directory_list: EL_ARRAYED_LIST [SOURCE_DIRECTORY]

	ecf_dir: EL_DIR_PATH

	ecf_name: ZSTRING
		do
			Result := relative_ecf_path.base
		end

	ecf_path: EL_FILE_PATH
		do
			Result := repository.root_dir + relative_ecf_path
		end

	html_index_path: EL_FILE_PATH
		-- relative path to html index for ECF, and qualified with cluster name when specified in config.pyx

	relative_dir_path: EL_DIR_PATH
		do
			Result := dir_path.relative_path (repository.root_dir)
		end

	relative_ecf_path: EL_FILE_PATH

	source_dir_list: like new_source_dir_list

	sub_category: ZSTRING

	type: STRING
		do
			if is_library then
				Result := once "library"
			else
				Result := once "project"
			end
			if is_cluster then
				Result := Result + once " cluster"
			end
		end

feature -- Status query

	is_cluster: BOOLEAN
		-- True if classes are selected from one cluster in ecf

	is_library: BOOLEAN

feature -- Element change

	set_name_and_description (a_description: ZSTRING)
		-- set `name' from first line of `a_description' and `description_lines' from the remainder
		-- if `a_description' contains some text "See <file_path> for details", then set `description_lines'
		-- from text in referenced file path
		local
			lines: like description_lines
			doc_path, relative_doc_path: EL_FILE_PATH
			file_lines: EL_PLAIN_TEXT_LINE_SOURCE
		do
			create lines.make_with_lines (a_description)
			from lines.start until lines.after loop
				if lines.index = 1 then
					name := lines.item
				elseif lines.item.starts_with (See_details.begins) and then lines.item.has_substring (See_details.ends) then
					relative_doc_path := lines.item.substring_between (See_details.begins, See_details.ends, 1)
					doc_path := ecf_dir + relative_doc_path
					if doc_path.exists then
						create file_lines.make (doc_path)
						file_lines.do_all (agent description_lines.extend)
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
			parent_dir: EL_DIR_PATH; directory_group: SOURCE_DIRECTORY
			source_path: EL_FILE_PATH
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

feature {EIFFEL_CLASS_PARSER} -- Factory

	new_class (source_path: EL_FILE_PATH): EIFFEL_CLASS
		do
			if is_library then
				create {LIBRARY_CLASS} Result.make (source_path, Current, repository)
			else
				create Result.make (source_path, Current, repository)
			end
		end

	new_path_list: EL_FILE_PATH_LIST
		local
			list: EL_FILE_PATH_LIST
		do
			across source_dir_list as path loop
				if path.cursor_index = 1 then
					Result := OS.file_list (path.item, Eiffel_wildcard)
				else
					list := OS.file_list (path.item, Eiffel_wildcard)
					Result.append (list)
				end
			end
		end

	new_source_dir_list (cluster_nodes: EL_XPATH_NODE_CONTEXT_LIST; parent_dir: EL_DIR_PATH): EL_ARRAYED_LIST [EL_DIR_PATH]
		local
			source_dir: EL_DIR_PATH; location: ZSTRING; is_recursive: BOOLEAN
			sub_cluster_nodes: EL_XPATH_NODE_CONTEXT_LIST
		do
			create Result.make (cluster_nodes.count)
			across cluster_nodes as cluster loop
				location := cluster.node.attributes [Attribute_location]
				if cluster.node.attributes.has (Attribute_recursive) then
					is_recursive := cluster.node.attributes.boolean (Attribute_recursive)
				end
				if location.starts_with (Parent_dir_dots) then
					source_dir := parent_dir.parent.joined_dir_path (location.substring_end (4))
				elseif location.starts_with (Relative_location_symbol) then
					location.remove_head (Relative_location_symbol.count)
					source_dir := parent_dir.joined_dir_path (location)
				else
					source_dir := parent_dir.joined_dir_path (location)
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
		local
			words: EL_ZSTRING_LIST; steps: EL_PATH_STEPS
		do
			if is_library then
				if not dir_path.is_empty then
					steps := dir_path.relative_path (repository.root_dir)
					if steps.count >= 2 then
						create words.make_with_separator (steps.item (2), '_', False)
						Result := words.joined_propercase_words
					else
						create Result.make_empty
					end
				end
			else
				create Result.make_empty
			end
		end

feature {NONE} -- Implementation

	set_directory_list (parser: EIFFEL_CLASS_PARSER)
		local
			group_table: EL_GROUP_TABLE [EL_FILE_PATH, EL_DIR_PATH]
			directory_group: SOURCE_DIRECTORY; file_count: INTEGER
		do
			lio.put_labeled_string ("Reading classes", html_index_path)
			lio.put_new_line
			create group_table.make (agent {EL_FILE_PATH}.parent, sorted_path_list)
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

	Xpath_all_classes: STRING = "/system/target/root/@all_classes"

feature {NONE} -- Constants

	Dot: ZSTRING
		once
			Result := "."
		end

	Eiffel_wildcard: STRING = "*.e"

	Html: ZSTRING
		once
			Result := "html"
		end

	Library: ZSTRING
		once
			Result := "library"
		end

	Library_category: ZSTRING
		once
			Result := "Library"
		end

	Parent_dir_dots: ZSTRING
		once
			Result := "../"
		end

	Relative_location_symbol: ZSTRING
		once
			Result := "$|"
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

end
