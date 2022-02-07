note
	description: "OS file system routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-07 8:22:10 GMT (Monday 7th February 2022)"
	revision: "46"

deferred class
	EL_FILE_SYSTEM_ROUTINES_I

inherit
	EL_SHARED_DIRECTORY
		rename
			copy as copy_object
		end

	EL_MODULE_FILE
		rename
			copy as copy_object
		end

	EL_MODULE_ITERABLE
		rename
			copy as copy_object
		end

	EL_MODULE_DIRECTORY
		rename
			copy as copy_object,
			Directory as Stanard_directory
		end

	EL_FILE_OPEN_ROUTINES
		rename
			copy as copy_object
		end

	STRING_HANDLER
		rename
			copy as copy_object
		end

	EL_STRING_8_CONSTANTS
		rename
			copy as copy_object
		end

feature -- Access

	cached (relative_path: FILE_PATH; write_file: PROCEDURE [FILE_PATH]): FILE_PATH
		do
			Result := Stanard_directory.App_cache + relative_path
			if not Result.exists then
				write_file (Result)
			end
		end

	escaped_path (path: READABLE_STRING_GENERAL): ZSTRING
		-- escaped for use as command line argument
		-- On Unix characters like colon, space etc are prefixed with a backslash
		-- On Windows this results in a quoted string
		deferred
		end

	parent_set (path_list: ITERABLE [FILE_PATH]; ascending_order: BOOLEAN): EL_ARRAYED_LIST [DIR_PATH]
		-- set of all parent directories of file paths in list `path_list'
		-- if `ascending_order' is `True', results are sorted in ascending order of step count
		-- or else in reverse order
		local
			dir_set: EL_HASH_SET [DIR_PATH]; parent: DIR_PATH
		do
			-- assume average of 20 files per directory
			create dir_set.make ((iterable.count (path_list) // 20).min (10))
			across path_list as path loop
				parent := path.item.parent
				if not parent.is_empty then
					dir_set.put (parent)
				end
			end
			create Result.make_from_array (dir_set.to_array)
			Result.order_by (agent {DIR_PATH}.step_count, ascending_order)
		end

feature -- File lists

	files (a_dir_path: DIR_PATH; recursively: BOOLEAN): like Directory.files
			--
		do
			if recursively then
				Result := Directory.named (a_dir_path).recursive_files
			else
				Result := Directory.named (a_dir_path).files
			end
		end

	files_with_extension (
		a_dir_path: DIR_PATH; extension: READABLE_STRING_GENERAL; recursively: BOOLEAN
	): like Directory.files
			--
		do
			if recursively then
				Result := Directory.named (a_dir_path).recursive_files_with_extension (extension)
			else
				Result := Directory.named (a_dir_path).files_with_extension (extension)
			end
		end

feature -- Basic operations

	delete_empty_branch (dir_path: DIR_PATH)
			--
		require
			path_exists: dir_path.exists
		local
			dir_steps: EL_PATH_STEPS
			dir: like Directory.named
		do
			dir_steps := dir_path
			from dir := Directory.named (dir_path) until dir_steps.is_empty or else not dir.is_empty loop
				dir.delete
				dir_steps.remove_tail (1)
				dir.make_with_name (dir_steps.to_string_32)
			end
		end

	delete_if_empty (dir_path: DIR_PATH)
			--
		require
			path_exists: dir_path.exists
		local
			dir: like Directory.named
		do
			dir := Directory.named (dir_path)
			if dir.is_empty then
				dir.delete
			end
		end

	make_directory (a_dir_path: DIR_PATH)
			-- recursively create directory
		local
			dir_parent: DIR_PATH
		do
			if not (a_dir_path.is_empty or else a_dir_path.exists) then
				dir_parent := a_dir_path.parent
				make_directory (dir_parent)
				if dir_parent.exists_and_is_writeable then
					Directory.named (a_dir_path).create_dir
				end
			end
		end

	make_parents (path_list: ITERABLE [FILE_PATH])
		-- create directory structure to create files in `path_list'
		do
			across parent_set (path_list, True) as set loop
				make_directory (set.item)
			end
		end

	remove_file, remove_directory, remove_path (a_path: EL_PATH)
			--
		require
			exists: a_path.exists
		do
			File.info (a_path, False).delete
		end

	rename_file (a_file_path, new_file_path: FILE_PATH)
			-- change name of file to new_name. If preserve_extension is true, the original extension is preserved
		require
			file_exists: a_file_path.exists
		do
			File.info (a_file_path, False).rename_file (new_file_path)
		end

feature -- Status query

	directory_exists (a_path: DIR_PATH): BOOLEAN
		do
			Result := File.info (a_path, False).exists
		end

	is_directory (a_path: EL_PATH): BOOLEAN
		-- True if file not empty
		local
			l_file: RAW_FILE
		do
			create l_file.make_with_name (a_path.as_string_32)
			Result := l_file.exists and then l_file.is_directory
		end

	is_writeable_directory (dir_path: DIR_PATH): BOOLEAN
		do
			Result := Directory.named (dir_path).is_writable
		end

	path_exists (a_path: EL_PATH): BOOLEAN
		do
			Result := File.info (a_path, False).exists
		end

end