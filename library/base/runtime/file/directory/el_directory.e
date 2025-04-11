note
	description: "Object to manage file system directory accessible via ${EL_SHARED_DIRECTORY}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-11 17:52:37 GMT (Friday 11th April 2025)"
	revision: "34"

class
	EL_DIRECTORY

inherit
	DIRECTORY
		rename
			entries as path_entries,
			internal_detachable_name_pointer as internal_path_pointer,
			internal_name as internal_path,
			make as make_from_string,
			make_open_read as make_open_read_general,
			set_name as set_internal_path,
			path as ise_path,

			-- obsolete routines
			delete_content_with_action as obs_delete_content_with_action,
			lastentry as obs_lastentry,
			name as obs_name,
			recursive_delete_with_action as obs_recursive_delete_with_action,
			readentry as obs_readentry
		export
			{NONE} obs_readentry, obs_lastentry, obs_recursive_delete_with_action, obs_delete_content_with_action
			{EL_DIRECTORY_ITERATION_CURSOR, DIRECTORY} file_info, last_entry_pointer
		redefine
			delete_content, internal_path, set_internal_path
		end

	ITERABLE [STRING_32]

	EL_MODULE_EXCEPTION; EL_MODULE_FILE_SYSTEM

	EL_DIRECTORY_CONSTANTS; EL_STRING_8_CONSTANTS

create
	make_default, make

feature -- Initialization

	make (dir_path: DIR_PATH)
			-- Create directory object for directory
			-- of name `dn'.
		do
			make_default
			set_path (dir_path)
		end

	make_default
		do
			create internal_path.make_empty
			create internal_path_pointer.make (0)
			mode := Close_directory
			-- if mode is not set to closed then this may trigger a segmentation fault
			-- during the final garbage collection on application exit. See routine `dispose'.
		ensure
			closed: is_closed
		end

feature -- Access

	directories: EL_SORTABLE_ARRAYED_LIST [DIR_PATH]
		do
			create Result.make (20)
			read_entries (Result, Type_directory, Empty_string_8)
		ensure
			object_comparison: Result.object_comparison
		end

	directories_with_extension (extension: READABLE_STRING_GENERAL): EL_SORTABLE_ARRAYED_LIST [DIR_PATH]
		do
			create Result.make (20)
			Result.compare_objects
			read_entries (Result, Type_directory, extension)
		ensure
			object_comparison: Result.object_comparison
		end

	entries: EL_ARRAYED_LIST [EL_PATH]
		do
			create Result.make (20)
			read_entries (Result, Type_any, Empty_string_8)
		ensure
			object_comparison: Result.object_comparison
		end

	entries_with_extension (extension: READABLE_STRING_GENERAL): EL_SORTABLE_ARRAYED_LIST [EL_PATH]
		do
			create Result.make (20)
			read_entries (Result, Type_any, extension)
		ensure
			object_comparison: Result.object_comparison
		end

	files: EL_FILE_PATH_LIST
		do
			create Result.make (20)
			read_entries (Result, Type_file, Empty_string_8)
		ensure
			object_comparison: Result.object_comparison
		end

	files_with_extension (extension: READABLE_STRING_GENERAL): like files
		do
			create Result.make (20)
			if is_readable then
				read_entries (Result, Type_file, extension)
			end
		ensure
			object_comparison: Result.object_comparison
		end

	path: DIR_PATH
		do
			Result := internal_path
		end

	recursive_directories: like directories
		do
			create Result.make (20)
			read_recursive_entries (Result, Type_directory, Empty_string_8)
		ensure
			object_comparison: Result.object_comparison
		end

	recursive_files: like files
		do
			create Result.make (20)
			read_recursive_entries (Result, Type_file, Empty_string_8)
		ensure
			object_comparison: Result.object_comparison
		end

	recursive_files_with_extension (extension: READABLE_STRING_GENERAL): like files
		do
			create Result.make (20)
			read_recursive_entries (Result, Type_file, extension)
		ensure
			object_comparison: Result.object_comparison
		end

feature -- Measurement

	directory_count (recursive: BOOLEAN): INTEGER
		do
			Result := entry_type_count (recursive, Type_directory)
		end

	file_count (recursive: BOOLEAN): INTEGER
		do
			Result := entry_type_count (recursive, Type_file)
		end

feature -- Element change

	set_to_current
		-- same as `set_path_name (".")'
		do
			internal_path.wipe_out
			internal_path.append_character ('.')
			set_internal_path (internal_path)
		end

	set_path (a_path: EL_PATH)
		do
			internal_path.wipe_out; a_path.append_to_32 (internal_path)
			set_internal_path (internal_path)
		ensure
			name_set: internal_path ~ a_path.as_string_32
		end

	set_path_name (a_path: READABLE_STRING_GENERAL)
			-- Set `path' with `a_path'.
		local
			sg: EL_STRING_GENERAL_ROUTINES
		do
			if attached internal_path as l_path then
				l_path.wipe_out
				if attached sg.super_readable_general (a_path) as general then
					general.append_to_string_32 (l_path)
				end
				set_internal_path (l_path)
			end
		end

feature -- Status query

	has_directory_with_extension (extension: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if at least one directory exists with extension `extension'
		do
			Result := across Current as entry some
				entry.existing_item_matches_type_and_extension (Type_directory, extension)
			end
		end

	has_executable (a_name: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := across Current as entry some
				entry.existing_item_matches_name_and_type (a_name, Type_executable_file)
			end
		end

	has_file_name (a_name: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := across Current as entry some
				entry.existing_item_matches_name_and_type (a_name, Type_file)
			end
		end

	has_file_with_extension (extension: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if at least one file exists with extension `extension'
		do
			Result := across Current as entry some
				entry.existing_item_matches_type_and_extension (Type_file, extension)
			end
		end

	is_following_symlinks: BOOLEAN

feature -- Removal

	delete_content
			-- Delete all files located in current directory and it's subdirectories.
		do
			delete_content_with_action (Void, Void, 0)
		end

	delete_content_with_action (
		on_delete: detachable PROCEDURE [LIST [EL_PATH]]; is_cancel_requested: detachable PREDICATE
		file_number: INTEGER
	)
		-- Delete all files located in current directory and its
		-- subdirectories.
		--
		-- `action' is called each time at most `file_number' files has
		-- been deleted and before the function exits. If `a_file_number'
		-- is non-positive, `action' is not called.
		-- `action' may be set to Void if you don't need it.
		--
		-- Same for `is_cancel_requested'.
		-- Make it return `True' to cancel the operation.
		-- `is_cancel_requested' may be set to Void if you don't need it.
		local
			manager: EL_DIRECTORY_DELETE_MANAGER
		do
			create manager.make (on_delete, is_cancel_requested, file_number)
			internal_delete_content_with_action (manager, True)
		ensure
			stills_exists: path.exists
		end

	delete_files (extension: STRING)
		do
			across files_with_extension (extension) as l_path loop
				File_system.remove_file (l_path.item)
			end
		end

	delete_with_action (
		on_delete: detachable PROCEDURE [LIST [EL_PATH]]; is_cancel_requested: detachable PREDICATE
		file_number: INTEGER
	)
			-- Recursively delete directory, its files and its subdirectories.
			--
			-- `on_delete' is called each time at most `file_number' files has
			-- been deleted and before the function exits. If `a_file_number'
			-- is non-positive, `on_delete' is not called.
		local
			manager: EL_DIRECTORY_DELETE_MANAGER
		do
			create manager.make (on_delete, is_cancel_requested, file_number)
			internal_delete_with_action (manager, True)
		end

feature -- Status setting

	set_is_following_symlinks (v: BOOLEAN)
			-- Should `read_entries' follow symlinks or not?
		do
			is_following_symlinks := v
		ensure
			is_following_symlinks_set: is_following_symlinks = v
		end

feature {EL_SHARED_DIRECTORY} -- Access

	named (a_path: DIR_PATH): EL_DIRECTORY
		do
			set_path (a_path)
			Result := Current
		end

	named_as (a_name: READABLE_STRING_GENERAL): EL_DIRECTORY
		do
			set_path_name (a_name)
			Result := Current
		end

	named_as_current: EL_DIRECTORY
		-- same as `named_as (".")'
		do
			set_to_current; Result := Current
		end

feature {EL_DIRECTORY, EL_DIRECTORY_ITERATION_CURSOR} -- Implementation

	entry_type_count (recursive: BOOLEAN; entry_type: INTEGER): INTEGER
		local
			sub_directory: detachable EL_DIRECTORY
		do
			if recursive then
				create sub_directory.make_default
			end
			across Current as entry loop
				if not entry.is_current_or_parent then
					if entry.is_directory then
						if entry_type = Type_directory then
							Result := Result + 1
						end
						if attached sub_directory as sub_dir then
							sub_dir.set_path_name (entry.item_path (False))
							Result := Result + sub_dir.entry_type_count (True, entry_type)
						end

					elseif entry_type = Type_file then
						Result := Result + 1
					end
				end
			end
		end

	internal_delete_content_with_action (manager: EL_DIRECTORY_DELETE_MANAGER; top_level: BOOLEAN)
		local
			old_is_following_symlinks: BOOLEAN
			sub_dir: EL_DIRECTORY; file_path: FILE_PATH
		do
			old_is_following_symlinks := is_following_symlinks
			is_following_symlinks := False
			create sub_dir.make_default
			across Current as entry until manager.is_cancel_requested loop
				if not entry.is_current_or_parent and then entry.exists then
					if not entry.is_symlink and then entry.is_directory then
						sub_dir.set_path_name (entry.item_path (False))
						sub_dir.internal_delete_with_action (manager, False)
					elseif entry.is_writable then
						file_path := entry.item_file_path
						File_system.remove_file (file_path)
						manager.on_delete (file_path)
					end
				end
			end
			if top_level then
				manager.on_delete_final
			end
			is_following_symlinks := old_is_following_symlinks
		end

	internal_delete_with_action (manager: EL_DIRECTORY_DELETE_MANAGER; top_level: BOOLEAN)
		require
			directory_exists: exists
		do
			if top_level then
				internal_delete_content_with_action (manager, False)
			else
				internal_delete_content_with_action (manager, top_level)
			end
			if not manager.is_cancel_requested then
				delete
				manager.on_delete (create {DIR_PATH}.make (internal_path))
			end
			if top_level then
				manager.on_delete_final
			end
		end

	new_cursor: EL_DIRECTORY_ITERATION_CURSOR
		require else
			read_permission: is_readable
		do
			create Result.make (Current)
		end

	read_entries (list: LIST [EL_PATH]; type: INTEGER; extension: READABLE_STRING_GENERAL)
		require
			is_open: true
		do
			list.compare_objects
		-- check for read permission
			if is_readable then
				across Current as entry loop
					if not entry.is_current_or_parent and then entry.exists
						and then (extension.count > 0 implies entry.item_has_extension (extension))
						and then entry.item_matches_type (type)
					then
						if entry.is_directory then
							if (type = Type_any or type = Type_directory) then
								list.extend (entry.item_dir_path)
							end
						elseif (type = Type_any or type = Type_file) then
							list.extend (entry.item_file_path)
						end
					end
				end
			end
		end

	read_recursive_entries (list: LIST [EL_PATH]; type: INTEGER; extension: READABLE_STRING_GENERAL)
		local
			saved_path: ZSTRING; directory_list: like directories; old_count: INTEGER
		do
			old_count := list.count
			read_entries (list, type, extension)
			saved_path := internal_path
			if type = Type_directory then
				create directory_list.make (list.count - old_count)
				if attached {like directories} list as dir_list and not directory_list.full then
					from dir_list.go_i_th (old_count + 1) until dir_list.after loop
						directory_list.extend (dir_list.item)
						dir_list.forth
					end
				end
			else
				directory_list := directories
			end
			across directory_list as dir loop
				set_path (dir.item)
				read_recursive_entries (list, type, extension)
			end
			set_path_name (saved_path)
		end

	set_internal_path (a_path: STRING_32)
			-- Set `path' with `a_path'.
		do
			internal_path := a_path
			internal_path_pointer := file_info.file_name_to_pointer (a_path, internal_path_pointer)
		end

feature {EL_DIRECTORY_ITERATION_CURSOR} -- Internal attributes

	internal_path: STRING_32

end