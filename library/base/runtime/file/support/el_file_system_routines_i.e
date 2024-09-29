note
	description: "OS file system accessible via class ${EL_MODULE_FILE_SYSTEM}"
	notes: "[
		Benchmark 5 June 2024

		Loop to remove steps until path does not have a parent

			path.parent:        43.0 times (100%)
			steps.remove_tail:  25.0 times (-41.9%)

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-26 16:40:11 GMT (Thursday 26th September 2024)"
	revision: "61"

deferred class
	EL_FILE_SYSTEM_ROUTINES_I

inherit
	ANY

	EL_STRING_GENERAL_ROUTINES

	EL_MODULE_FILE; EL_MODULE_ITERABLE

	EL_MODULE_DIRECTORY
		rename
			Directory as Standard_directory
		end

	EL_SHARED_DIRECTORY

feature -- Access

	cached (relative_path: FILE_PATH; write_file: PROCEDURE [FILE_PATH]): FILE_PATH
		do
			Result := Standard_directory.App_cache + relative_path
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
			create dir_set.make_equal ((iterable.count (path_list) // 20).min (10))
			across path_list as path loop
				parent := path.item.parent
				if not parent.is_empty then
					dir_set.put (parent)
				end
			end
			create Result.make_from_array (dir_set.to_list.to_array)
			Result.order_by (agent {DIR_PATH}.step_count, ascending_order)
		end

feature -- File lists

	files (dir_path: DIR_PATH; recursively: BOOLEAN): like Directory.files
		do
			if recursively then
				Result := Directory.named (dir_path).recursive_files
			else
				Result := Directory.named (dir_path).files
			end
		end

	files_with_extension (
		dir_path: DIR_PATH; extension: READABLE_STRING_GENERAL; recursively: BOOLEAN

	): like Directory.files
		do
			if recursively then
				Result := Directory.named (dir_path).recursive_files_with_extension (extension)
			else
				Result := Directory.named (dir_path).files_with_extension (extension)
			end
		end

feature -- Basic operations

	delete_empty_branch (dir_path: DIR_PATH)
		-- delete all parents of `dir_path' that do not have any directory entries
		require
			path_exists: dir_path.exists
		local
			dir: like Directory.named; break: BOOLEAN; path: DIR_PATH
		do
			path := dir_path.twin
			if path.has_parent then
				from dir := Directory.named (path) until break or else not dir.is_empty loop
					dir.delete
					path := path.parent
					if (path.is_absolute and then path.has_parent) or else not path.is_empty then
						dir.make_with_name (path)
					else
						break := True
					end
				end
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

	make_directory (path: DIR_PATH)
		-- recursively create directory
		do
			if not path.is_empty and then not path.exists and then attached path.parent as parent_dir then
				if parent_dir.exists_and_is_writeable then
					Directory.named (path).create_dir
				else
					make_directory (parent_dir)
					if parent_dir.exists_and_is_writeable then
						Directory.named (path).create_dir
					else
						check
							parent_writeable: False
						end
					end
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
		ensure
			renamed: new_file_path.exists
		end

feature -- Status query

	directory_exists (a_path: DIR_PATH): BOOLEAN
		do
			Result := File.exists (a_path)
		end

	is_directory (a_path: EL_PATH): BOOLEAN
		-- True if file not empty
		local
			l_file: RAW_FILE
		do
			create l_file.make_with_name (a_path)
			Result := l_file.exists and then l_file.is_directory
		end

	is_writeable_directory (dir_path: DIR_PATH): BOOLEAN
		do
			Result := Directory.named (dir_path).is_writable
		end

	path_exists (a_path: EL_PATH): BOOLEAN
		do
			Result := File.exists (a_path)
		end

end