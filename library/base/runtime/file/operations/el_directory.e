note
	description: "Summary description for {EL_DIRECTORY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-23 19:55:03 GMT (Thursday 23rd June 2016)"
	revision: "4"

class
	EL_DIRECTORY

inherit
	DIRECTORY
		rename
			make as make_from_string,
			set_name as set_path,
			entries as path_entries,
			internal_name as internal_path,
			name as obsolete_name,
			readentry as obsolete_readentry,
			lastentry as obsolete_lastentry
		export
			{NONE} obsolete_readentry, obsolete_lastentry
		redefine
			default_create, delete_content_with_action
		end

	EL_MODULE_FILE_SYSTEM
		undefine
			default_create
		end

	EL_STRING_CONSTANTS
		undefine
			default_create
		end

create
	default_create, make, make_open_read, make_with_path

feature -- Initialization

	default_create
		do
			internal_path := Empty_string_8
			create internal_detachable_name_pointer.make (0)
		end

	make (dir_path: EL_DIR_PATH)
			-- Create directory object for directory
			-- of name `dn'.
		do
			make_with_name (dir_path)
		end

feature -- Access

	directories: EL_ARRAYED_LIST [EL_DIR_PATH]
		do
			create Result.make (20)
			read_entries (Result, Type_directory, Empty_string_8)
		end

	directories_with_extension (extension: READABLE_STRING_GENERAL): EL_ARRAYED_LIST [EL_DIR_PATH]
		do
			create Result.make (20)
			read_entries (Result, Type_directory, extension)
		end

	entries: EL_ARRAYED_LIST [EL_PATH]
		do
			create Result.make (20)
			read_entries (Result, Type_any, Empty_string_8)
		end

	entries_with_extension (extension: READABLE_STRING_GENERAL): EL_ARRAYED_LIST [EL_PATH]
		do
			create Result.make (20)
			read_entries (Result, Type_any, extension)
		end

	files: EL_ARRAYED_LIST [EL_FILE_PATH]
		do
			create Result.make (20)
			read_entries (Result, Type_file, Empty_string_8)
		end

	files_with_extension (extension: READABLE_STRING_GENERAL): like files
		do
			create Result.make (20)
			read_entries (Result, Type_file, extension)
		end

	recursive_directories: like directories
		do
			create Result.make (20)
			read_recursive_entries (Result, Type_directory, Empty_string_8)
		end

	recursive_files: like files
		do
			create Result.make (20)
			read_recursive_entries (Result, Type_file, Empty_string_8)
		end

	recursive_files_with_extension (extension: READABLE_STRING_GENERAL): like files
		do
			create Result.make (20)
			read_recursive_entries (Result, Type_file, extension)
		end

feature -- Status query

	is_following_symlinks: BOOLEAN

	has_file_name (a_name: ZSTRING): BOOLEAN
		do
			Result := has_entry_of_type (a_name, Type_file)
		end

	has_executable (a_name: ZSTRING): BOOLEAN
		do
			Result := has_entry_of_type (a_name, Type_executable_file)
		end

feature {NONE} -- Status setting

	set_is_following_symlinks (v: BOOLEAN)
			-- Should `read_entries' follow symlinks or not?
		do
			is_following_symlinks := v
		ensure
			is_following_symlinks_set: is_following_symlinks = v
		end
feature -- Basic operations

	delete_content_with_action (
			action: detachable PROCEDURE [ANY, TUPLE [LIST [READABLE_STRING_GENERAL]]]
			is_cancel_requested: detachable FUNCTION [ANY, TUPLE, BOOLEAN]
			file_number: INTEGER)
			-- Delete all files located in current directory and its
			-- subdirectories.
			--
			-- `action' is called each time `file_number' files has
			-- been deleted and before the function exits. If `a_file_number'
			-- is non-positive, nothing is done. If `a_file_number' is greater than
			-- 1024, we limit its value to 1024.
			-- `action' may be set to Void if you don't need it.
			--
			-- Same for `is_cancel_requested'.
			-- Make it return `True' to cancel the operation.
			-- `is_cancel_requested' may be set to Void if you don't need it.
		local
			l_path, l_file_name: PATH; file: detachable RAW_FILE
			info: like file_info; dir, dir_temp: detachable EL_DIRECTORY
			l_last_entry_pointer: like last_entry_pointer
			name: detachable STRING_32; l_file_count: INTEGER; requested_cancel: BOOLEAN
			deleted_files: ARRAYED_LIST [READABLE_STRING_32]
		do
			l_file_count := 1
				-- We limit `file_number' to something reasonable.
			create deleted_files.make (file_number.min (1024))

			from
					-- To delete files we do not need to follow symbolic links.
				info := file_info
				info.set_is_following_symlinks (False)
					-- Create a new directory that we will use to list all of its content.
				create dir_temp.make_open_read (internal_path)
				dir_temp.start
				dir_temp.read_next
				l_last_entry_pointer := dir_temp.last_entry_pointer
				l_path := path
			until
				l_last_entry_pointer = default_pointer or requested_cancel
			loop
					-- Ignore current and parent directories.
				name := info.pointer_to_file_name_32 (l_last_entry_pointer)
				if not is_current_or_parent (name) then
						-- Avoid creating too many objects.
					l_file_name := path.extended (name)
					info.update (l_file_name.name)
					if info.exists then
						if not info.is_symlink and then info.is_directory then
								-- Start the recursion for true directory, we do not follow links to delete their content.
							if dir /= Void then
								dir.make_with_path (l_file_name)
							else
								create dir.make_with_path (l_file_name)
							end
							dir.recursive_delete_with_action (action, is_cancel_requested, file_number)
						elseif info.is_writable then
							if file /= Void then
								file.reset_path (l_file_name)
							else
								create file.make_with_path (l_file_name)
							end
							file.delete
						end

							-- Add the name of the deleted file to our array
							-- of deleted files.
						deleted_files.extend (l_file_name.name)
						l_file_count := l_file_count + 1

							-- If `file_number' has been reached, call `action'.
						if file_number > 0 and then l_file_count > file_number then
							if action /= Void then
								action.call ([deleted_files])
							end
							if is_cancel_requested /= Void then
								requested_cancel := is_cancel_requested.item (Void)
							end
							deleted_files.wipe_out
							l_file_count := 1
						end
					end
				end
				dir_temp.read_next
				l_last_entry_pointer := dir_temp.last_entry_pointer
			end
			dir_temp.close

				-- If there is more than one deleted file and no
				-- agent has been called, call one now.
			if l_file_count > 1 and action /= Void then
				action.call ([deleted_files])
			end
		rescue
			if dir_temp /= Void and then not dir_temp.is_closed then
				dir_temp.close
			end
		end

	delete_files (extension: STRING)
		do
			files_with_extension (extension).do_all (agent File_system.remove_file)
		end

	read_next
			-- Read next directory entry making result available in `last_entry_pointer'.
		require
			is_opened: not is_closed
		do
			last_entry_pointer := eif_dir_next (directory_pointer)
		end

feature {EL_DIRECTORY} -- Implementation

	file_count (list: EL_ARRAYED_LIST [EL_PATH]): INTEGER
		local
			i: INTEGER
		do
			from i := 1 until i > list.count loop
				if attached {EL_FILE_PATH} list [i] then
					Result := Result + 1
				end
				i := i + 1
			end
		end

	has_entry_of_type (a_name: STRING_32; a_type: INTEGER): BOOLEAN
		require
			is_open: true
		local
			dir_path: EL_DIR_PATH; info: like file_info; dir: EL_DIRECTORY
			name: STRING_32
		do
			dir_path := path
			info := file_info
			create dir.make_open_read (internal_path)
			from dir.start; dir.read_next until Result or dir.last_entry_pointer = default_pointer loop
				name := info.pointer_to_file_name_32 (dir.last_entry_pointer)
				if a_name.same_string (name) then
					info.update (dir_path.joined_dir_path (name))
					if info.exists then
						inspect a_type
							when Type_any then
								Result := True
							when Type_file then
								Result := info.is_plain
							when Type_executable_file then
								Result := info.is_plain and then info.is_executable
							else
						end
					end
				end
				if not Result then
					dir.read_next
				end
			end
			dir.close
		end

	is_current_or_parent (a_name: STRING_32): BOOLEAN
		do
			Result := a_name ~ Dots_current_directory or else a_name ~ Dots_parent_directory
		end

	read_entries (list: LIST [EL_PATH]; type: INTEGER; extension: READABLE_STRING_GENERAL)
		require
			is_open: true
		local
			dir_path, entry_path: EL_DIR_PATH; info: like file_info; dir: EL_DIRECTORY
			name: STRING_32; extension_matches: BOOLEAN; dot_position: INTEGER
		do
			dir_path := path; info := file_info
			info.set_is_following_symlinks (is_following_symlinks)
			create dir.make_open_read (internal_path)
			from dir.start; dir.read_next until dir.last_entry_pointer = default_pointer loop
				name := info.pointer_to_file_name_32 (dir.last_entry_pointer)
				if not is_current_or_parent (name) then
					entry_path := dir_path.joined_dir_path (name)
					info.update (entry_path)
					if info.exists then
						if extension.is_empty then
							extension_matches := True
						elseif name.count > extension.count then
							dot_position := name.count - extension.count
							extension_matches := name [dot_position] = '.' and then name.ends_with_general (extension)
						else
							extension_matches := False
						end
						if extension_matches then
							if info.is_directory then
								if (type = Type_any or type = Type_directory) then
									list.extend (entry_path)
								end
							elseif (type = Type_any or type = Type_file) then
								list.extend (dir_path + name)
							end
						end
					end
				end
				dir.read_next
			end
			dir.close
		end

	read_recursive_entries (list: LIST [EL_PATH]; type: INTEGER; extension: READABLE_STRING_GENERAL)
		local
			l_path: like internal_path; l_directories: like directories
			old_count: INTEGER
		do
			old_count := list.count
			read_entries (list, type, extension)
			l_path := internal_path
			if type = Type_directory then
				create l_directories.make (list.count - old_count)
				if attached {like directories} list as dir_list and not l_directories.full then
					from dir_list.go_i_th (old_count + 1) until dir_list.after loop
						l_directories.extend (dir_list.item)
						dir_list.forth
					end
				end
			else
				l_directories := directories
			end
			if not l_directories.is_empty then
				from l_directories.start until l_directories.after loop
					set_path (l_directories.item.unicode)
					read_recursive_entries (list, type, extension)
					l_directories.forth
				end
				set_path (l_path)
			end
		end

feature {NONE} -- Constants

	Dots_current_directory: STRING_32 = "."

	Dots_parent_directory: STRING_32 = ".."

	Type_any: INTEGER = 3

	Type_directory: INTEGER = 2

	Type_file: INTEGER = 1

	Type_executable_file: INTEGER = 4

end