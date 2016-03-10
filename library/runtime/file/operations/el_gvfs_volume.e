note
	description: "Gnome Virtual Filesystem volume"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_GVFS_VOLUME

inherit
	EL_MODULE_DIRECTORY
		redefine
			default_create
		end

create
	make, make_with_volume

feature {NONE} -- Initialization

	default_create
		do
			create name.make_empty
		end

	make (a_uri_root: like uri_root; a_is_windows_format: BOOLEAN)
		do
			default_create
			uri_root := a_uri_root; is_windows_format := a_is_windows_format
		end

	make_with_volume (a_name: like name; a_is_windows_format: BOOLEAN)
		local
			command: like Mount_list_command
		do
			default_create
			name := name; is_windows_format := a_is_windows_format; command := Mount_list_command
			if a_name ~ Current_directory then
				create {EL_DIR_PATH} uri_root.make_from_latin1 (".")
			elseif a_name ~ Home_directory then
				create {EL_DIR_URI_PATH} uri_root.make_from_path (Directory.home)
			else
				execute (command)
				command.uri_root_table.search (a_name)
				if command.uri_root_table.found then
					uri_root := command.uri_root_table.found_item
				else
					create uri_root
				end
			end
		end

feature -- Access attributes

	name: ASTRING

	uri_root: EL_DIR_PATH

feature -- File operations

	copy_file_from (volume_path: EL_FILE_PATH; destination_dir: EL_DIR_PATH)
			-- copy file from volume to external
		require
			volume_path_relative_to_root: not volume_path.is_absolute
			destination_not_on_volume: not destination_dir.to_string.starts_with (uri_root.to_string)
		do
			copy_file (uri_root + volume_path, destination_dir)
		end

	copy_file_to (source_path: EL_FILE_PATH; volume_dir: EL_DIR_PATH)
			-- copy file from volume to external
		require
			volume_dir_relative_to_root: not volume_dir.is_absolute
			source_not_on_volume: not source_path.to_string.starts_with (uri_root.to_string)
		do
			copy_file (source_path, uri_root.joined_dir_path (volume_dir))
		end

	delete_directory (dir_path: EL_DIR_PATH)
			--
		require
			is_relative_to_root: not dir_path.is_absolute
			is_directory_empty (dir_path)
		do
			remove (uri_root.joined_dir_path (dir_path))
		end

	delete_directory_files (dir_path: EL_DIR_PATH; wild_card: ASTRING)
			--
		require
			is_relative_to_root: not dir_path.is_absolute
		local
			extension: ASTRING; match_found: BOOLEAN
			command: like File_list_command
		do
			command := File_list_command
			if directory_exists (dir_path) then
				if wild_card.starts_with ("*.") then
					extension := wild_card.substring (3, wild_card.count)
				else
					create extension.make_empty
				end
				command.reset
				command.put_variable (uri_root.joined_dir_path (dir_path), Var_uri)
				execute (command)
				across command.file_list as file_path loop
					match_found := False
					if not extension.is_empty then
						match_found := file_path.item.extension ~ extension
					else
						match_found := True
					end
					if match_found then
						delete_file (dir_path + file_path.item)
					end
				end
			end
		end

	delete_empty_branch (dir_path: EL_DIR_PATH)
		require
			is_relative_to_root: not dir_path.is_absolute
		local
			dir_steps: EL_PATH_STEPS
		do
			from dir_steps := dir_path until dir_steps.is_empty or else not is_directory_empty (dir_steps) loop
				delete_directory (dir_steps)
				dir_steps.remove_last
			end
		end

	delete_file (file_path: EL_FILE_PATH)
			--
		require
			is_relative_to_root: not file_path.is_absolute
		do
			remove (uri_root + file_path)
		end

	delete_if_empty (dir_path: EL_DIR_PATH)
		require
			is_relative_to_root: not dir_path.is_absolute
		do
			if is_directory_empty (dir_path) then
				delete_directory (dir_path)
			end
		end

	make_directory (dir_path: EL_DIR_PATH)
			-- recursively create directory
		require
			relative_path: not dir_path.is_absolute
		do
			make_uri (uri_root.joined_dir_path (dir_path))
		end

feature -- Status query

	directory_exists (dir_path: EL_DIR_PATH): BOOLEAN
		require
			is_relative_to_root: not dir_path.is_absolute
		do
			Result := uri_exists (uri_root.joined_dir_path (dir_path))
		end

	file_exists (file_path: EL_FILE_PATH): BOOLEAN
		require
			is_relative_to_root: not file_path.is_absolute
		do
			Result := uri_exists (uri_root + file_path)
		end

	is_directory_empty (dir_path: EL_DIR_PATH): BOOLEAN
		local
			command: like Get_file_count_commmand
		do
			command := Get_file_count_commmand
			command.put_variable (uri_root.joined_dir_path (dir_path), Var_uri)
			execute (command)
			Result := command.is_empty
		end

	is_valid: BOOLEAN
		do
			Result := not uri_root.is_empty
		end

	is_windows_format: BOOLEAN
		-- True if the file system is a windows format

	path_translation_enabled: BOOLEAN
		-- True if all paths are translated for windows format

	has_error: BOOLEAN
		-- True if last operation failed

feature -- Element change

	set_uri_root (a_uri_root: like uri_root)
		do
			uri_root := a_uri_root
		end

feature -- Status change

	enable_path_translation
		do
			path_translation_enabled := True
		end

feature {NONE} -- Implementation

	execute (command: EL_GENERAL_OS_COMMAND)
		do
			has_error := False
			command.execute
			has_error := command.has_error
		end

	copy_file (source_path: EL_PATH; destination_path: EL_PATH)
		local
			command: like Copy_command
		do
			command := Copy_command
			command.put_variable (source_path, Var_source_path)
			command.put_variable (destination_path, Var_destination_path)
			execute (command)
		end

	make_uri (a_uri: EL_DIR_PATH)
		local
			command: like Make_directory_command
			parent_uri: EL_DIR_PATH
		do
			if not uri_exists (a_uri) then
				if a_uri.has_parent then
					parent_uri := a_uri.parent
					if not uri_exists (parent_uri) then
						make_uri (parent_uri)
					end
					command := Make_directory_command
					command.put_variable (a_uri, Var_uri)
					execute (command)
				end
			end
		end

	move (source_path: EL_PATH; destination_path: EL_PATH)
		local
			command: like Move_command
		do
			command := Move_command
			command.put_variable (source_path, Var_source_path)
			command.put_variable (destination_path, Var_uri)
			execute (command)
		end

	remove (a_uri: EL_PATH)
			--
		local
			command: like Remove_command
		do
			command := Remove_command
			command.put_variable (a_uri, Var_uri)
			execute (command)
		end

	uri_exists (a_uri: EL_PATH): BOOLEAN
		local
			command: like get_file_type_commmand
		do
			command := get_file_type_commmand
			command.put_variable (a_uri, Var_uri)
			execute (command)
			Result := command.file_exists
		end

feature {NONE} -- Commands

	Copy_command: EL_GENERAL_OS_COMMAND
		once
			create Result.make ("[
				gvfs-copy "$source_path" "$destination_path"
			]")
		end

	File_list_command: EL_GVFS_FILE_LIST_COMMAND
		once
			create Result
		end

	Get_file_count_commmand: EL_GVFS_FILE_COUNT_COMMAND
		once
			create Result
		end

	Get_file_type_commmand: EL_GVFS_FILE_EXISTS_COMMAND
		once
			create Result
		end

	List_command: EL_GENERAL_OS_COMMAND
		once
			create Result.make ("[
				gvfs-ls "$uri"
			]")
		end

	Make_directory_command: EL_GENERAL_OS_COMMAND
		once
			create Result.make ("[
				gvfs-mkdir "$uri"
			]")
		end

	Mount_list_command: EL_GVFS_MOUNT_LIST_COMMAND
		once
			create Result
		end

	Move_command: EL_GENERAL_OS_COMMAND
		once
			create Result.make ("[
				gvfs-move "$source_path" "$uri"
			]")
		end

	Remove_command: EL_GENERAL_OS_COMMAND
		once
			create Result.make ("[
				gvfs-rm "$uri"
			]")
		end

feature {NONE} -- Constants

	Current_directory: ASTRING
		once
			Result := "."
		end

	Home_directory: ASTRING
		once
			Result := "~"
		end

	Var_destination_path: ASTRING
		once
			Result := "destination_path"
		end

	Var_source_path: ASTRING
		once
			Result := "source_path"
		end

	Var_uri: ASTRING
		once
			Result := "uri"
		end

end
