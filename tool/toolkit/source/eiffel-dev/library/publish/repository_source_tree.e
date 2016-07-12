note
	description: "Eiffel repository source tree"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 7:22:11 GMT (Friday 8th July 2016)"
	revision: "4"

class
	REPOSITORY_SOURCE_TREE

inherit
	EIFFEL_SOURCE_TREE
		redefine
			getter_function_table, make_default
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
			Precursor
		end

	make_with_name (a_repository: like repository; a_name: like name; a_dir_path: like dir_path)
		do
			make (a_repository)
			name := a_name; dir_path := a_dir_path
		end

feature -- Access

	directory_list: EL_ARRAYED_LIST [EIFFEL_SOURCE_DIRECTORY]

	repository: EIFFEL_REPOSITORY_PUBLISHER

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

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor
			Result.append_tuples (<<
				["directory_list", agent: like directory_list do Result := directory_list end]
			>>)
		end

feature {NONE} -- Constants

	Library: ZSTRING
		once
			Result := "library"
		end

end
