note
	description: "[
		Test using a set of text files generated in workarea directory.
		The file data is a unique natural number.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-13 19:09:48 GMT (Friday 13th September 2024)"
	revision: "21"

deferred class
	EL_GENERATED_FILE_DATA_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		redefine
			on_prepare
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

feature {NONE} -- Event handling

	on_prepare
		do
			Precursor
			file_set := new_file_set (False)
			dir_set := new_dir_set (False)
			File_system.make_parents (file_set)
			across file_set as path loop
				write_file (path.item)
			end
		end

feature {NONE} -- Implementation

	new_dir_set (is_absolute: BOOLEAN): EL_HASH_SET [DIR_PATH]
		local
			dir_path, root_dir: DIR_PATH
		do
			if is_absolute then
				root_dir := Work_area_absolute_dir
			else
				root_dir := Work_area_dir
			end
			create Result.make_equal ((file_set.count // 2).min (3))
			Result.put (root_dir)
			across new_file_set (is_absolute) as path loop
				from dir_path := path.item.parent until Result.has (dir_path) loop
					Result.put (dir_path)
					dir_path := dir_path.parent
				end
			end
			Result.prune (root_dir)
		end

	new_file_set (is_absolute: BOOLEAN): like file_set
		local
			path_list: EL_ZSTRING_LIST
		do
			create path_list.make_with_lines (file_path_list)
			create Result.make_equal (path_list.count)
			across path_list as list loop
				if is_absolute then
					Result.put (Work_area_absolute_dir + list.item)
				else
					Result.put (Work_area_dir + list.item)
				end
			end
		end

	total_file_size: INTEGER
		do
			across file_set as path loop
				Result := Result + File.byte_count (path.item)
			end
		end

	write_file (path: FILE_PATH)
		do
			if attached open (path, Write) as l_file then
				l_file.put_string (path.base)
				l_file.close
			end
		end

feature {NONE} -- Internal attributes

	dir_set: EL_HASH_SET [DIR_PATH]

	file_set: EL_HASH_SET [FILE_PATH]

feature {NONE} -- Factory

	file_path_list: READABLE_STRING_GENERAL
		-- Manifest of files to be created relative to `work_area_dir' separated by newline character
		deferred
		end

end