note
	description: "[
		Process files specified in a Pyxis format source manifest as for example:
		[https://github.com/finnianr/Eiffel-Loop/blob/master/sources.pyx sources.pyx]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-16 12:08:25 GMT (Saturday 16th September 2023)"
	revision: "22"

deferred class
	SOURCE_MANIFEST_COMMAND

inherit
	EL_APPLICATION_COMMAND
		redefine
			error_check
		end

	EL_FILE_LIST_COMMAND
		redefine
			execute, make_default
		end

	EL_MODULE_FILE_SYSTEM

	EL_CHARACTER_32_CONSTANTS

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_manifest_path_or_directory: FILE_PATH)
		local
			l_manifest: SOURCE_MANIFEST
		do
			if File_system.is_directory (a_manifest_path_or_directory) then
				create l_manifest.make_from_directory (a_manifest_path_or_directory.to_string)
				is_directory := True
			else
				create l_manifest.make_from_file (a_manifest_path_or_directory)
			end
			make_from_manifest (l_manifest)

			manifest_path_or_directory.copy (a_manifest_path_or_directory)
		end

	make_default
		do
			Precursor
			create manifest.make_default
			create manifest_path_or_directory
		end

	make_from_manifest (a_manifest: SOURCE_MANIFEST)
		do
			make_default
			manifest := a_manifest
		end

feature -- Status query

	is_directory: BOOLEAN
		-- `True' if sources files specified by directory path rather than manifest

	source_trees_read: BOOLEAN
		do
			Result := manifest.source_trees_read
		end

feature -- Basic operations

	error_check (application: EL_FALLIBLE)
		-- check for errors before execution
		local
			error: EL_ERROR_DESCRIPTION; missing_list: EL_ZSTRING_LIST
		do
			create missing_list.make (5)
			across manifest.source_tree_list as list loop
				if not list.item.dir_path.exists then
					missing_list.extend (list.item.dir_path)
					missing_list.last.prepend (space * 2)
				end
			end
			if missing_list.count > 0 then
				create error.make ("source")
				error.set_lines (Manifest_error #$ [manifest.name])
				error.append (missing_list)

				application.put (error)
			end
		end

	execute
		do
			read_manifest_files

			across manifest.source_tree_list as location loop
				if location.item.dir_path.exists then
					lio.put_line (location.item.dir_path)
				else
					lio.put_labeled_string ("Not found", location.item.dir_path)
					lio.put_new_line
				end
			end
			lio.put_new_line
			Precursor
		end

feature {NONE} -- Implementation

	do_with_file (source_path: FILE_PATH)
		deferred
		end

	new_file_list: EL_FILE_PATH_LIST
		do
			Result := manifest.file_list
		end

	read_manifest_files
		do
			if is_directory then
				lio.put_labeled_string ("Reading directory", manifest_path_or_directory.to_string)
			else
				lio.put_labeled_string ("Reading manifest", manifest_path_or_directory.base_name)
			end
			lio.put_new_line
			manifest.read_source_trees
		end

feature {NONE} -- Internal attributes

	manifest: SOURCE_MANIFEST

	manifest_path_or_directory: FILE_PATH

feature {NONE} -- Constants

	Manifest_error: ZSTRING
		once
			Result := "[
				Error in sources manifest: #
				Directories not found:
			]"
		end

end