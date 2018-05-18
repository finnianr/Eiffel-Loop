note
	description: "Gnome Virtual Filesystem volume"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-10 19:08:04 GMT (Thursday 10th May 2018)"
	revision: "5"

class
	EL_GVFS_VOLUME

inherit
	EL_MODULE_DIRECTORY

create
	make, make_with_volume

feature {NONE} -- Initialization

	make (a_uri_root: like uri_root; a_is_windows_format: BOOLEAN)
		do
			make_default
			uri_root := a_uri_root; is_windows_format := a_is_windows_format
		end

	make_default
		do
			create name.make_empty
			uri_root := Default_uri_root
		end

	make_with_volume (a_name: like name; a_is_windows_format: BOOLEAN)
		do
			make_default
			name := a_name; is_windows_format := a_is_windows_format
			if a_name ~ Current_directory then
				create {EL_DIR_PATH} uri_root.make_from_general (".")
			elseif a_name ~ Home_directory then
				create {EL_DIR_URI_PATH} uri_root.make_from_path (Directory.home)
			else
				reset_uri_root
			end
		end

feature -- Access

	name: ZSTRING

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

	delete_directory_files (dir_path: EL_DIR_PATH; wild_card: ZSTRING)
			--
		require
			is_relative_to_root: not dir_path.is_absolute
		local
			extension: ZSTRING; match_found: BOOLEAN
			command: like File_list_command
		do
			command := File_list_command
			if directory_exists (dir_path) then
				if wild_card.starts_with (Star_dot) then
					extension := wild_card.substring_end (3)
				else
					create extension.make_empty
				end
				command.reset
				command.put_path (Var_uri, uri_root.joined_dir_path (dir_path))
				command.execute
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
			command.put_path (Var_uri, uri_root.joined_dir_path (dir_path))
			command.execute
			Result := command.is_empty
		end

	is_valid: BOOLEAN
		do
			Result := uri_root /= Default_uri_root
		end

	is_windows_format: BOOLEAN
		-- True if the file system is a windows format

	path_translation_enabled: BOOLEAN
		-- True if all paths are translated for windows format

feature -- Element change

	extend_uri_root (relative_dir: EL_DIR_PATH)
		do
			make_directory (relative_dir)
			uri_root.append_dir_path (relative_dir)
		end

	reset_uri_root
		local
			command: like Mount_list_command
		do
			command := Mount_list_command
			command.execute
			if command.uri_root_table.has_key (name) then
				uri_root := command.uri_root_table.found_item
			else
				uri_root := Default_uri_root
			end
		end

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

	copy_file (source_path: EL_PATH; destination_path: EL_PATH)
		local
			command: like Copy_command
		do
			command := Copy_command
			command.put_path (Var_source_path, source_path)
			command.put_path (Var_destination_path, destination_path)
			command.execute
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
					command.put_path (Var_uri, a_uri)
					command.execute
				end
			end
		end

	move (source_path: EL_PATH; destination_path: EL_PATH)
		local
			command: like Move_command
		do
			command := Move_command
			command.put_path (Var_source_path, source_path)
			command.put_path (Var_uri, destination_path)
			command.execute
		end

	remove (a_uri: EL_PATH)
			--
		local
			command: like Remove_command
		do
			command := Remove_command
			command.put_path (Var_uri, a_uri)
			command.execute
		end

	uri_exists (a_uri: EL_PATH): BOOLEAN
		local
			command: like get_file_type_commmand
		do
			command := get_file_type_commmand
			command.put_path (Var_uri, a_uri)
			command.execute
			Result := command.file_exists
		end

feature {NONE} -- Standard commands

	Copy_command: EL_GVFS_OS_COMMAND
		once
			create Result.make ("gvfs-copy $source_path $destination_path")
		end

	Make_directory_command: EL_GVFS_OS_COMMAND
		once
			create Result.make ("gvfs-mkdir $uri")
		end

	Move_command: EL_GVFS_OS_COMMAND
		once
			create Result.make ("gvfs-move $source_path $uri")
		end

	Remove_command: EL_GVFS_REMOVE_FILE_COMMAND
		once
			create Result.make
		end

feature {NONE} -- Special commands

	File_list_command: EL_GVFS_FILE_LIST_COMMAND
		once
			create Result.make
		end

	Get_file_count_commmand: EL_GVFS_FILE_COUNT_COMMAND
		once
			create Result.make
		end

	Get_file_type_commmand: EL_GVFS_FILE_EXISTS_COMMAND
		once
			create Result.make
		end

	Mount_list_command: EL_GVFS_MOUNT_LIST_COMMAND
		once
			create Result.make
		end

feature {NONE} -- Constants

	Current_directory: ZSTRING
		once
			Result := "."
		end

	Default_uri_root: EL_DIR_PATH
		once
			create Result
		end

	Home_directory: ZSTRING
		once
			Result := "~"
		end

	Root_dir: ZSTRING
		once
			Result := "/"
		end

	Star_dot: ZSTRING
		once
			Result := "*."
		end

	Var_destination_path: ZSTRING
		once
			Result := "destination_path"
		end

	Var_source_path: ZSTRING
		once
			Result := "source_path"
		end

	Var_uri: ZSTRING
		once
			Result := "uri"
		end

end
