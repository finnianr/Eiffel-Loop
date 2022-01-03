note
	description: "Object to manage file system directory accessible via [$source EL_SHARED_DIRECTORY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:52:09 GMT (Monday 3rd January 2022)"
	revision: "20"

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
			{NONE}	obs_readentry, obs_lastentry, obs_recursive_delete_with_action,
						obs_delete_content_with_action

			{EL_DIRECTORY_ITERATION_CURSOR, DIRECTORY} file_info, last_entry_pointer
		redefine
			delete_content, internal_path, set_internal_path
		end

	ITERABLE [STRING_32]

	EL_STRING_8_CONSTANTS

	EL_MODULE_FILE_SYSTEM

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

	directories: EL_ARRAYED_LIST [DIR_PATH]
		do
			create Result.make (20)
			read_entries (Result, Type_directory, Empty_string_8)
		ensure
			object_comparison: Result.object_comparison
		end

	directories_with_extension (extension: READABLE_STRING_GENERAL): EL_ARRAYED_LIST [DIR_PATH]
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

	entries_with_extension (extension: READABLE_STRING_GENERAL): EL_ARRAYED_LIST [EL_PATH]
		do
			create Result.make (20)
			read_entries (Result, Type_any, extension)
		ensure
			object_comparison: Result.object_comparison
		end

	files: EL_SORTABLE_ARRAYED_LIST [FILE_PATH]
		do
			create Result.make (20)
			read_entries (Result, Type_file, Empty_string_8)
		ensure
			object_comparison: Result.object_comparison
		end

	files_with_extension (extension: READABLE_STRING_GENERAL): like files
		do
			create Result.make (20)
			read_entries (Result, Type_file, extension)
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
		local
			sub_dir: EL_DIRECTORY
		do
			create sub_dir.make_default
			across Current as entry loop
				if not entry.is_current_or_parent then
					if entry.is_directory then
						Result := Result + 1
						if recursive then
							sub_dir.set_path_name (entry.item_path (False))
							Result := Result + sub_dir.directory_count (True)
						end
					end
				end
			end
		end

	file_count (recursive: BOOLEAN): INTEGER
		local
			sub_dir: EL_DIRECTORY
		do
			create sub_dir.make_default
			across Current as entry loop
				if not entry.is_current_or_parent then
					if entry.is_directory then
						if recursive then
							sub_dir.set_path_name (entry.item_path (False))
							Result := Result + sub_dir.file_count (True)
						end
					else
						Result := Result + 1
					end
				end
			end
		end

feature -- Element change

	set_path (a_path: EL_PATH)
		do
			internal_path.wipe_out; a_path.append_to_32 (internal_path)
			set_internal_path (internal_path)
		ensure
			name_set: internal_path ~ a_path.as_string_32
		end

	set_path_name (a_name: READABLE_STRING_GENERAL)
			-- Set `name' with `a_name'.
		do
			internal_path.wipe_out; internal_path.append_string_general (a_name)
			set_internal_path (internal_path)
		end

feature -- Status query

	has_executable (a_name: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := has_entry_of_type (string_32.from_general (a_name, False), Type_executable_file)
		end

	has_file_name (a_name: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := has_entry_of_type (string_32.from_general (a_name, False), Type_file)
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

feature {NONE} -- Status setting

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

feature {EL_DIRECTORY, EL_DIRECTORY_ITERATION_CURSOR} -- Implementation

	has_entry_of_type (a_name: STRING_32; a_type: INTEGER): BOOLEAN
		do
			across Current as entry until Result loop
				if a_name ~ entry.item and then entry.exists then
					inspect a_type
						when Type_any then
							Result := True
						when Type_file then
							Result := entry.is_plain
						when Type_executable_file then
							Result := entry.is_plain and then entry.is_executable
						else
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
		do
			create Result.make (Current)
		end

	read_entries (list: LIST [EL_PATH]; type: INTEGER; extension: READABLE_STRING_GENERAL)
		require
			is_open: true
		local
			name: STRING_32; extension_matches: BOOLEAN; dot_position: INTEGER
		do
			list.compare_objects
			across Current as entry loop
				if not entry.is_current_or_parent then
					name := entry.item
					if entry.exists then
						if extension.is_empty then
							extension_matches := True
						elseif name.count > extension.count then
							dot_position := name.count - extension.count
							extension_matches := name [dot_position] = '.' and then name.ends_with_general (extension)
						else
							extension_matches := False
						end
						if extension_matches then
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
		end

	read_recursive_entries (list: LIST [EL_PATH]; type: INTEGER; extension: READABLE_STRING_GENERAL)
		local
			l_path: DIR_PATH; directory_list: like directories
			old_count: INTEGER
		do
			old_count := list.count
			read_entries (list, type, extension)
			create l_path.make (internal_path)
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
			set_path (l_path)
		end

	set_internal_path (a_name: STRING_32)
			-- Set `name' with `a_name'.
		do
			internal_path := a_name
			internal_path_pointer := file_info.file_name_to_pointer (a_name, internal_path_pointer)
		end

	string_32: EL_STRING_32_ROUTINES
		do
		end

feature {EL_DIRECTORY_ITERATION_CURSOR} -- Internal attributes

	internal_path: STRING_32

feature {NONE} -- Constants

	Type_any: INTEGER = 3

	Type_directory: INTEGER = 2

	Type_executable_file: INTEGER = 4

	Type_file: INTEGER = 1

end
