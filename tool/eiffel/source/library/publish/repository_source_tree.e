note
	description: "Eiffel repository source tree"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-05 13:06:22 GMT (Thursday 5th April 2018)"
	revision: "8"

class
	REPOSITORY_SOURCE_TREE

inherit
	SOURCE_TREE
		rename
			make as make_tree
		redefine
			getter_function_table, building_action_table, make_default,
			on_context_exit,  Xpath_dir_path
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
			make_tree (a_repository.root_dir)
			repository := a_repository
			create distributer.make (repository.thread_count)
		end

	make_default
		do
			create directory_list.make_empty
			create description_lines.make_empty
			create ecf_name.make_empty
			create class_tuple_list.make (0)
			Precursor
		end

	make_with_name (a_repository: like repository; a_name: like name; a_dir_path: like dir_path)
		do
			make (a_repository)
			name := a_name; dir_path := a_repository.root_dir.joined_dir_path (a_dir_path)
		end

feature -- Access

	description_lines: EL_ZSTRING_LIST

	directory_list: EL_ARRAYED_LIST [SOURCE_DIRECTORY]

	ecf_name: ZSTRING

feature -- Element change

	set_description_lines (a_description: ZSTRING)
		do
			create description_lines.make_with_lines (a_description)
		end

feature -- Basic operations

	extend_source_directory (is_final: BOOLEAN)
		local
			tuple: like new_tuple_item
		do
			class_tuple_list.wipe_out
			if is_final then
				distributer.do_final
				distributer.collect_final (class_tuple_list)
			else
				distributer.collect (class_tuple_list)
			end
			across class_tuple_list as t loop
				tuple := t.item
				if not attached {LIBRARY_CLASS} tuple.eiffel_class then
					repository.example_classes.extend (tuple.eiffel_class)
				end
				tuple.source_directory.class_list.extend (tuple.eiffel_class)
			end
		end

	read_source_files
		local
			parent_dir: EL_DIR_PATH; source_directory: SOURCE_DIRECTORY; source_path: EL_FILE_PATH
			class_list: like directory_list.item.class_list; list: like sorted_path_list
		do
			lio.put_path_field ("Eiffel", dir_path)
			lio.put_new_line
			create parent_dir
			directory_list.wipe_out
			list := sorted_path_list
			from list.start until list.after loop
				source_path := list.path
				if source_path.parent /~ parent_dir then
					create class_list.make (10)
					create source_directory.make (dir_path.relative_path (repository.root_dir), class_list, directory_list.count + 1)
					directory_list.extend (source_directory)
					parent_dir := source_path.parent
				end
				lio.put_character ('.')
				if list.index \\ 80 = 0 or list.islast then
					lio.put_new_line
				end
				distributer.wait_apply (agent new_tuple_item (source_directory, source_path))
				extend_source_directory (list.islast)
				list.forth
			end
		end

feature {NONE} -- Factory

	new_description_lines (file_path: EL_FILE_PATH): like description_lines
		local
			file_lines: EL_FILE_LINE_SOURCE
		do
			create Result.make (10)
			create file_lines.make (file_path)
			file_lines.do_all (agent Result.extend)
		end

	new_tuple_item (source_directory: SOURCE_DIRECTORY; source_path: EL_FILE_PATH): like class_tuple_list.item
		local
			l_class: EIFFEL_CLASS; relative_html_path: EL_FILE_PATH
		do
			relative_html_path := source_path.relative_path (dir_path).with_new_extension ("html")
			if source_path.relative_path (repository.root_dir).first_step ~ Library then
				create {LIBRARY_CLASS} l_class.make (source_path, relative_html_path, repository)
			else
				create l_class.make (source_path, relative_html_path, repository)
			end
			Result := [l_class, source_directory]
		end

feature {NONE} -- Implementation

	class_tuple_list: ARRAYED_LIST [TUPLE [eiffel_class: EIFFEL_CLASS; source_directory: SOURCE_DIRECTORY]]

	distributer: EL_FUNCTION_DISTRIBUTER [like class_tuple_list.item]
		-- multi-threaded work distributer

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

feature {NONE} -- Build from Pyxis

	building_action_table: EL_PROCEDURE_TABLE
		do
			Result := Precursor + 	["@ecf",						agent do ecf_name := node.to_string end] +
											["description/text()",	agent set_description_from_node]
		end

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

feature {NONE} -- Constants

	Dot_emd_extension: ZSTRING
		once
			Result := ".emd"
		end

	Library: ZSTRING
		once
			Result := "library"
		end

	Translater: MARKDOWN_TRANSLATER
		once
			create Result.make (repository.web_address)
		end

	Xpath_dir_path: STRING
		once
			Result := "@dir"
		end
end
