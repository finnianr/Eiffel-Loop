note
	description: "Gnome Virtual Filesystem volume"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-20 8:17:25 GMT (Sunday 20th February 2022)"
	revision: "16"

class
	EL_GVFS_VOLUME

inherit
	ANY
	EL_MODULE_DIRECTORY
	EL_MODULE_TUPLE

create
	make, make_default, make_with_mounts

feature {NONE} -- Initialization

	make_default
		do
			create name.make_empty
			uri_root := Default_uri_root
		end

	make (a_name: like name; a_is_windows_format: BOOLEAN)
		do
			make_with_mounts (a_name, mount_table, a_is_windows_format)
		end

	make_with_mounts (a_name: like name; a_table: like mount_table; a_is_windows_format: BOOLEAN)
		do
			uri_root := new_uri_root (a_name, a_table); is_windows_format := a_is_windows_format
			name := a_name
		end

feature -- Access

	name: ZSTRING

	uri_root: EL_URI

feature -- File operations

	copy_file_from (volume_path: FILE_PATH; destination_dir: DIR_PATH)
			-- copy file from volume to external
		require
			volume_path_relative_to_root: not volume_path.is_absolute
			destination_not_on_volume: not uri_root.is_file implies not destination_dir.to_uri.starts_with (uri_root)
		do
			copy_file (uri_root.joined (volume_path), destination_dir)
		end

	copy_file_to (source_path: FILE_PATH; volume_dir: DIR_PATH)
			-- copy file from volume to external
		require
			volume_dir_relative_to_root: not volume_dir.is_absolute
			source_not_on_volume: not source_path.to_uri.starts_with (uri_root)
		do
			copy_file (source_path.to_uri, uri_root.joined (volume_dir))
		end

	delete_directory (dir_path: DIR_PATH)
			--
		require
			is_relative_to_root: not dir_path.is_absolute
			is_directory_empty (dir_path)
		do
			remove_file (uri_root.joined (dir_path))
		end

	delete_directory_files (dir_path: DIR_PATH; wild_card: ZSTRING)
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
				command.put_uri (Var.uri, uri_root.joined (dir_path))
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

	delete_empty_branch (dir_path: DIR_PATH)
		require
			is_relative_to_root: not dir_path.is_absolute
		do
			if attached dir_path.steps as steps then
				from until steps.is_empty or else not is_directory_empty (steps) loop
					delete_directory (steps)
					steps.remove_tail (1)
				end
			end
		end

	delete_file (file_path: FILE_PATH)
			--
		require
			is_relative_to_root: not file_path.is_absolute
		do
			remove_file (uri_root.joined (file_path))
		end

	delete_if_empty (dir_path: DIR_PATH)
		require
			is_relative_to_root: not dir_path.is_absolute
		do
			if is_directory_empty (dir_path) then
				delete_directory (dir_path)
			end
		end

	make_directory (dir_path: DIR_PATH)
			-- recursively create directory
		require
			relative_path: not dir_path.is_absolute
		do
			make_uri_directory (uri_root.joined (dir_path))
		end

feature -- Status query

	directory_exists (dir_path: DIR_PATH): BOOLEAN
		require
			is_relative_to_root: not dir_path.is_absolute
		do
			Result := uri_exists (uri_root.joined (dir_path))
		end

	file_exists (file_path: FILE_PATH): BOOLEAN
		require
			is_relative_to_root: not file_path.is_absolute
		do
			Result := uri_exists (uri_root.joined (file_path))
		end

	is_directory_empty (dir_path: DIR_PATH): BOOLEAN
		local
			command: like Get_file_count_commmand
		do
			command := Get_file_count_commmand
			command.put_uri (Var.uri, uri_root.joined (dir_path))
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

	extend_uri_root (relative_dir: DIR_PATH)
		require
			valid_volume: is_valid
		do
			make_directory (relative_dir)
			uri_root.join (relative_dir)
		end

	reset_uri_root
		do
			uri_root := new_uri_root (name, mount_table)
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

	copy_file (source_path: EL_URI; destination_path: EL_URI)
		local
			command: like Copy_command
		do
			command := Copy_command
			command.put_uri (Var.source_path, source_path)
			command.put_uri (Var.destination_path, destination_path)
			command.execute
		end

	make_uri_directory (a_uri: EL_URI)
		local
			command: like Make_directory_command
			parent_uri: EL_URI
		do
			if not uri_exists (a_uri) then
				if a_uri.has_parent then
					parent_uri := a_uri.parent
					if not uri_exists (parent_uri) then
						make_uri_directory (parent_uri)
					end
					command := Make_directory_command
					command.put_uri (Var.uri, a_uri)
					command.execute
				end
			end
		end

	mount_table: EL_GVFS_MOUNT_TABLE
		do
			create Result.make
		end

	move_file (source_path: EL_PATH; destination_path: EL_PATH)
		local
			command: like Move_command
		do
			command := Move_command
			command.put_path (Var.source_path, source_path)
			command.put_path (Var.uri, destination_path)
			command.execute
		end

	new_uri_root (a_name: ZSTRING; table: like mount_table): like uri_root
		do
			if a_name ~ Current_directory then
				Result := Directory.current_working.to_uri
			elseif a_name ~ Home_directory then
				Result := Directory.home.to_uri
			elseif table.has_key (a_name) then
				Result := table.found_item
			else
				Result := Default_uri_root
			end
		end

	remove_file (a_uri: EL_URI)
			--
		local
			command: like Remove_command
		do
			command := Remove_command
			command.put_uri (Var.uri, a_uri)
			command.execute
		end

	uri_exists (a_uri: EL_URI): BOOLEAN
		local
			command: like get_file_type_commmand
		do
			command := get_file_type_commmand
			command.put_uri (Var.uri, a_uri)
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

feature {NONE} -- Constants

	Current_directory: ZSTRING
		once
			Result := "."
		end

	Default_uri_root: EL_URI
		once
			create Result.make_empty
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

	Var: TUPLE [destination_path, source_path, uri: STRING]
		once
			create Result
			Tuple.fill (Result, "destination_path, source_path, uri")
		end

end