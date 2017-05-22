note
	description: "Eiffel repository source tree"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-09 11:23:05 GMT (Tuesday 9th August 2016)"
	revision: "2"

class
	REPOSITORY_SOURCE_TREE

inherit
	EIFFEL_SOURCE_TREE
		redefine
			getter_function_table, building_action_table, make_default,
			on_context_exit
		end

	EL_MODULE_LOG
		undefine
			is_equal
		end

create
	make, make_with_name

feature {NONE} -- Initialization

	make (a_repository: like repository)
			--
		do
			make_default
			repository := a_repository
		end

	make_default
		do
			create directory_list.make_empty
			create description_lines.make_empty
			create ecf_name.make_empty
			Precursor
		end

	make_with_name (a_repository: like repository; a_name: like name; a_dir_path: like dir_path)
		do
			make (a_repository)
			name := a_name; dir_path := a_dir_path
		end

feature -- Access

	description_lines: EL_ZSTRING_LIST

	directory_list: EL_ARRAYED_LIST [EIFFEL_SOURCE_DIRECTORY]

	ecf_name: ZSTRING

feature -- Element change

	set_description_lines (a_description: ZSTRING)
		do
			create description_lines.make_with_lines (a_description)
		end

feature -- Basic operations

	read_source_files
		local
			parent_dir: EL_DIR_PATH; source_directory: EIFFEL_SOURCE_DIRECTORY
			class_list: like directory_list.item.class_list; relative_html_path: EL_FILE_PATH
			eiffel_class: EIFFEL_CLASS
		do
			lio.put_path_field ("Eiffel", dir_path)
			lio.put_new_line
			create parent_dir
			directory_list.wipe_out
			across sorted_path_list as path loop
				if path.item.parent /~ parent_dir then
					create class_list.make (10)
					create source_directory.make (dir_path, class_list, directory_list.count + 1)
					directory_list.extend (source_directory)
					parent_dir := path.item.parent
				end
				lio.put_character ('.')
				if path.cursor_index \\ 80 = 0 or else path.cursor_index = path_list.count then
					lio.put_new_line
				end
				relative_html_path := path.item.relative_path (dir_path).with_new_extension ("html")
				if path.item.relative_path (repository.root_dir).first_step ~ Library then
					create {LIBRARY_EIFFEL_CLASS} eiffel_class.make (path.item, relative_html_path, repository)
				else
					create eiffel_class.make (path.item, relative_html_path, repository)
					repository.example_classes.extend (eiffel_class)
				end
				source_directory.class_list.extend (eiffel_class)
			end
		end

feature {NONE} -- Implementation

	new_description_lines (file_path: EL_FILE_PATH): like description_lines
		local
			file_lines: EL_FILE_LINE_SOURCE
		do
			create Result.make (10)
			create file_lines.make (file_path)
			file_lines.do_all (agent Result.extend)
		end

	repository: EIFFEL_REPOSITORY_PUBLISHER

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor
			Result.append_tuples (<<
				["directory_list",		agent: like directory_list do Result := directory_list end],
				["has_description",		agent: BOOLEAN_REF do Result := (not description_lines.is_empty).to_reference end],
				["github_description",	agent: ZSTRING do Result := Translater.to_github_markdown (description_lines) end]
			>>)
		end

feature {NONE} -- Build from Pyxis

	on_context_exit
		local
			emd_path: EL_FILE_PATH
		do
			if description_lines.is_empty then
				emd_path := repository.file_path.parent + (dir_path.base + Dot_emd_extension)
				if emd_path.exists then
					description_lines := new_description_lines (emd_path)
				end
			end
		end

	set_description_from_node
		local
			text: ZSTRING
		do
			text := node.to_string
			if not text.has ('%N') and then text.ends_with (Dot_emd_extension)
				and then (repository.file_path.parent + text).exists
			then
				description_lines := new_description_lines (repository.file_path.parent + text)
			else
				create description_lines.make_with_lines (text)
			end
		end

	set_dir_path_from_node
		do
			dir_path := repository.root_dir.joined_dir_path (node.to_string)
		end

	building_action_table: EL_PROCEDURE_TABLE
		do
			Result := Precursor
			Result.append_tuples (<<
				["@dir",						agent set_dir_path_from_node],
				["@ecf",						agent do ecf_name := node.to_string end],
				["description/text()",	agent set_description_from_node]
			>>)
		end

feature {NONE} -- Constants

	Translater: MARKDOWN_TRANSLATER
		once
			create Result.make (repository.web_address)
		end

	Dot_emd_extension: ZSTRING
		once
			Result := ".emd"
		end

	Library: ZSTRING
		once
			Result := "library"
		end

end
