note
	description: "[
		Manage list of executable or package file paths with version number between hyphen and dot extension.
		
		Example:
		
			download/myching-amd64-1.1.2.deb
			download/MyChing-de-win32-1.1.2.exe
			download/MyChing-de-win32-1.1.4.exe
			download/MyChing-de-win64-1.1.2.exe
			download/MyChing-de-win64-1.1.4.exe
			download/MyChing-en-win32-1.1.2.exe
			download/MyChing-en-win32-1.1.4.exe
			download/MyChing-en-win64-1.1.2.exe
			download/MyChing-en-win64-1.1.4.exe		
		
		Accepts user input by command line to confirm deletions.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-31 11:11:30 GMT (Sunday 31st December 2023)"
	revision: "2"

class
	EL_VERSION_PATH_LIST

inherit
	EL_FILE_PATH_LIST
		rename
			make as make_sized,
			occurrences as path_occurrences
		export
			{NONE} all
			{ANY} new_cursor, start, forth, after, path, first_path, last_path
		redefine
			make_empty
		end

	EL_MODULE_LIO; EL_MODULE_OS; EL_MODULE_USER_INPUT

create
	make, make_empty

feature {NONE} -- Initialization

	make (a_dir_path: DIR_PATH; a_file_pattern: READABLE_STRING_GENERAL)
		do
			make_empty; dir_path := a_dir_path
			append_files (a_file_pattern)
		end

	make_empty
		do
			Precursor
			create dir_path
			create {EL_DELETE_FILE_COMMAND_IMP} delete_file_command.make_default
		end

feature -- Access

	path_version: EL_SOFTWARE_VERSION
		-- version of current path item
		do
			Result := new_path_version (path)
		end

	new_version_path_list (version: EL_SOFTWARE_VERSION): EL_FILE_PATH_LIST
		do
			create Result.make (10)
			from start until after loop
				if path_version ~ version then
					Result.extend (path)
				end
				forth
			end
		end

	sorted_version_list: EL_ARRAYED_LIST [EL_SOFTWARE_VERSION]
		do
			Result := version_set.to_list
			Result.sort (True)
		end

	version_set: EL_HASH_SET [EL_SOFTWARE_VERSION]
		do
			push_cursor
			create Result.make (count)
			from start until after loop
				if attached path_version as version then
					Result.put (version)
				end
				forth
			end
			pop_cursor
		end

feature -- Basic operations

	delete_range (name: READABLE_STRING_GENERAL)
		-- delete user specified range of versions by menu number
		local
			input_count: INTEGER; range: INTEGER_INTERVAL; input: EL_USER_INPUT_VALUE [INTEGER]
			version: EL_SOFTWARE_VERSION
		do
			display_versions (name)

			if attached sorted_version_list as version_list then
				range := 0 |..| version_list.count
				create input.make_valid ("Enter number to delete from earliest", "Invalid number", agent range.has)
				input_count := input.value
				across version_list as list until list.cursor_index > input_count loop
					version := list.item
					if attached new_version_path_list (version) as version_path_list then
						if version_path_list.count = 1 then
							lio.put_labeled_string ("Delete file", version_path_list.first_path)
						else
							across version_path_list as l_list loop
								lio.put_line (l_list.item.base)
							end
							lio.put_labeled_substitution (
								"Delete", "%S version %S files", [version_path_list.count, version.string]
							)
						end
					end
					if User_input.approved_action_y_n ("") then
						delete_version (version)
						lio.put_line ("Deleted")
					else
						lio.put_line ("Skipped")
					end
				end
				lio.put_new_line
			end
		end

	display_versions (name: READABLE_STRING_GENERAL)
		-- display menu of available versions
		do
			lio.put_new_line
			lio.put_path_field (Versions_of #$ [name], dir_path)
			lio.put_new_line

			if count > 0 then
				across sorted_version_list as version loop
					lio.put_index_labeled_string (version, Void, version.item.string)
					lio.put_new_line
				end
			else
				lio.put_line ("No versions found")
			end
			lio.put_new_line
		end

feature -- Status change

	set_admin_access (yes: BOOLEAN)
		-- sudo command on Unix
		do
			delete_file_command.sudo.set_state (yes)
		end

feature -- Element change

	append_files (a_file_pattern: READABLE_STRING_GENERAL)
		do
			if dir_path.exists and then attached OS.find_files_command (dir_path, a_file_pattern) as cmd then
				cmd.set_depth (1, 1) -- non-recursive
				cmd.execute
				if attached cmd.path_list as file_list then
					resize (count + file_list.count)
					across file_list as list loop
						if new_path_version (list.item) /= Default_version then
							extend (list.item)
						end
					end
				end
			end
		ensure
			all_versioned_paths:
				across sub_list (old count + 1, count) as list all
					new_path_version (list.item) /= Default_version
				end
		end

	delete_version (version: EL_SOFTWARE_VERSION)
		-- delete and remove all paths with `version'
		do
			if attached delete_file_command as cmd then
				from start until after loop
					if path_version ~ version then
						cmd.set_target_path (path)
						cmd.execute
						remove
					else
						forth
					end
				end
			end
		end

feature {NONE} -- Implementation

	new_path_version (a_path: FILE_PATH): EL_SOFTWARE_VERSION
		-- parse version from path like "el_eiffel-1.2.3.exe" with or without extension
		-- If not parseable `Result = Default_version'
		local
			version, name: ZSTRING
		do
			Result := Default_version
			name := a_path.base -- el_eiffel-1.2.3.exe
			if name.occurrences ('.') >= 2 and name.has ('-') then
				if not a_path.extension.is_natural then
					name := a_path.base_name -- el_eiffel-1.2.3
				end
				version := name.substring_to_reversed ('-', default_pointer)
				if version.occurrences ('.') = 2 then
					Result := version.to_latin_1
				end
			end
		end

feature {NONE} -- Internal attributes

	delete_file_command: EL_DELETE_FILE_COMMAND_I

	dir_path: DIR_PATH

feature {NONE} -- Constants

	Default_version: EL_SOFTWARE_VERSION
		once ("PROCESS")
			create Result
		end

	Versions_of: ZSTRING
		once
			Result := "VERSIONS of %S in"
		end

end