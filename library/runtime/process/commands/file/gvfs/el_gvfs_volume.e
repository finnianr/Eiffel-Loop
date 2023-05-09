note
	description: "[
		[https://www.commandlinux.com/man-page/man7/gvfs.7.html GIO virtual file system] volume
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-09 17:17:12 GMT (Tuesday 9th May 2023)"
	revision: "25"

class
	EL_GVFS_VOLUME

inherit
	ANY

	EL_GVFS_ROUTINES

	EL_MODULE_DIRECTORY; EL_MODULE_TUPLE

create
	make, make_default

feature {NONE} -- Initialization

	make (a_name: like name; a_is_windows_format: BOOLEAN)
		do
			make_with_mounts (a_name, new_uri_table, a_is_windows_format)
		end

	make_default
		do
			create name.make_empty
			uri_root := Empty_uri
		end

	make_with_mounts (a_name: ZSTRING; a_table: like new_uri_table; a_is_windows_format: BOOLEAN)
		do
			uri_root := new_uri_root (a_name, a_table); is_windows_format := a_is_windows_format
			name := a_name
		end

feature -- Access

	name: ZSTRING

	uri_root: EL_URI

	file_list (dir_path: DIR_PATH; extension: detachable STRING): EL_FILE_PATH_LIST
			--
		require
			is_relative_to_root: not dir_path.is_absolute
		do
			if directory_exists (dir_path) and then attached File_list_command as cmd then
				if attached extension as ext then
					cmd.set_extension (ext)
				else
					cmd.remove_extension
				end
				cmd.set_directory (uri_root, dir_path)
				cmd.execute

				Result := cmd.file_list
			else
				create Result.make_empty
			end
		end

	file_size (volume_path: FILE_PATH): INTEGER
		require
			volume_path_relative_to_root: not volume_path.is_absolute
		do
			if attached File_info_command as cmd then
				cmd.set_uri (uri_root.joined (volume_path))
				cmd.execute
				Result := cmd.file_size
			end
		end

feature -- File operations

	copy_file_from (volume_path: FILE_PATH; destination_dir: DIR_PATH)
			-- copy file from `volume_path' to external `destination_dir'
		require
			volume_path_relative_to_root: not volume_path.is_absolute
			destination_not_on_volume: not uri_root.is_file implies not destination_dir.to_uri.starts_with (uri_root)
		do
			copy_file (uri_root.joined (volume_path), destination_dir)
		end

	copy_file_to (source_path: FILE_PATH; volume_dir: DIR_PATH)
			-- copy file from external `source_path' to `volume_dir'
		require
			volume_dir_relative_to_root: not volume_dir.is_absolute
			source_not_on_volume: not source_path.to_uri.starts_with (uri_root)
		do
			copy_file (source_path.to_uri, uri_root.joined (volume_dir))
		end

	make_directory (dir_path: DIR_PATH)
			-- recursively create directory
		require
			relative_path: not dir_path.is_absolute
		do
			if not dir_path.is_empty then
				make_uri_directory (uri_root.joined (dir_path))
			end
		end

	remove_directory (dir_path: DIR_PATH)
			--
		require
			is_relative_to_root: not dir_path.is_absolute
			is_directory_empty (dir_path)
		do
			remove_file_uri (uri_root.joined (dir_path))
		end

	remove_directory_files (dir_path: DIR_PATH; wild_card: STRING)
			--
		require
			is_relative_to_root: not dir_path.is_absolute
		local
			extension: STRING
		do
			if wild_card.starts_with ("*.") then
				extension := wild_card.twin
				extension.remove_head (2)
			else
				create extension.make_empty
			end
			across file_list (dir_path, extension) as list loop
				remove_file (list.item)
			end
		end

	remove_empty_branch (dir_path: DIR_PATH)
		require
			is_relative_to_root: not dir_path.is_absolute
		do
			if attached dir_path.steps as steps then
				from until steps.is_empty or else not is_directory_empty (steps) loop
					remove_directory (steps)
					steps.remove_tail (1)
				end
			end
		end

	remove_file (file_path: FILE_PATH)
			--
		require
			is_relative_to_root: not file_path.is_absolute
		do
			remove_file_uri (uri_root.joined (file_path))
		end

	remove_if_empty (dir_path: DIR_PATH)
		require
			is_relative_to_root: not dir_path.is_absolute
		do
			if is_directory_empty (dir_path) then
				remove_directory (dir_path)
			end
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
		do
			if attached Get_file_count_commmand as cmd then
				cmd.set_uri (uri_root.joined (dir_path))
				cmd.execute
				Result := cmd.count = 0
			end
		end

	is_valid: BOOLEAN
		do
			Result := uri_root /= Empty_uri
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
			uri_root := new_uri_root (name, new_uri_table)
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

	copy_file (source_path, destination_path: EL_URI)
		do
			if attached Copy_command as cmd then
				cmd.set_source_uri (source_path)
				cmd.set_destination_uri (destination_path)
				cmd.execute
			end
		end

	make_uri_directory (a_uri: EL_URI)
		local
			parent_uri: EL_URI
		do
			if not uri_exists (a_uri) then
				if a_uri.has_parent then
					parent_uri := a_uri.parent
					if not uri_exists (parent_uri) then
						make_uri_directory (parent_uri)
					end
					if attached Make_directory_command as cmd then
						cmd.set_uri (a_uri)
						cmd.execute
					end
				end
			end
		end

	move_file (source_path, destination_path: EL_PATH)
		do
			if attached Move_command as cmd then
				cmd.set_source_path (source_path)
				cmd.set_destination_path (destination_path)
				cmd.execute
			end
		end

	new_uri_root (a_name: ZSTRING; table: like new_uri_table): like uri_root
		do
			if a_name.is_character ('.') then
				Result := Directory.current_working.to_uri

			elseif a_name.is_character ('~') then
				Result := Directory.home.to_uri

			elseif table.has_key (a_name) then
				Result := table.found_item

			else
				Result := Empty_uri
			end
		end

	remove_file_uri (a_uri: EL_URI)
		do
			if attached Remove_command as cmd then
				cmd.set_uri (a_uri)
				cmd.execute
			end
		end

	uri_exists (a_uri: EL_URI): BOOLEAN
		do
			if attached get_file_type_commmand as cmd then
				cmd.set_uri (a_uri)
				cmd.execute
				Result := cmd.file_exists
			end
		end

feature {NONE} -- Constants

	Empty_uri: EL_URI
		once
			create Result.make_empty
		end

end