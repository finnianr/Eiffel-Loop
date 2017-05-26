note
	description: "Test using a set of files generated in workarea directory"

	

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-25 10:34:56 GMT (Thursday 25th May 2017)"
	revision: "2"

deferred class
	EL_FILE_DATA_TEST_SET

inherit
	EQA_TEST_SET
		export
			{EL_SUB_APPLICATION} clean
		redefine
			on_prepare, on_clean
		end

	EL_MODULE_LOG
		undefine
			default_create
		end

	EL_MODULE_OS
		undefine
			default_create
		end

	EL_MODULE_DIRECTORY
		undefine
			default_create
		end

	EL_MODULE_EXECUTION_ENVIRONMENT
		undefine
			default_create
		end

	EL_TEST_CONSTANTS
		undefine
			default_create
		end

feature {NONE} -- Events

	on_clean
		do
			clean_work_area
		end

	on_prepare
		local
			l_dir: EL_DIRECTORY; text_file: PLAIN_TEXT_FILE
		do
			create file_checksums.make_equal (3)
			create l_dir.make (Work_area_dir)
			if l_dir.exists and not l_dir.is_empty then
				l_dir.recursive_delete
			end
			if not l_dir.exists then
				l_dir.create_dir
			end
			file_set := new_file_set
			across file_set as path loop
				OS.File_system.make_directory (path.item.parent)
				create text_file.make_open_write (path.item)
				text_file.put_integer (path.cursor_index)
				text_file.close
			end
		end

feature {NONE} -- Implementation

	store_checksum (file_path: EL_FILE_PATH)
		do
			file_checksums [file_path] := OS.File_system.file_checksum (file_path)
		end

	has_changed (file_path: EL_FILE_PATH): BOOLEAN
		require
			file_checksums.has (file_path)
		do
			Result := file_checksums [file_path] /= OS.File_system.file_checksum (file_path)
		end

	clean_work_area
		local
			l_dir: EL_DIRECTORY
		do
			create l_dir.make (Work_area_dir)
			l_dir.recursive_delete
		end

	file_set_absolute: EL_HASH_SET [EL_FILE_PATH]
		do
			create Result.make_equal (file_set.count)
			across file_set as path loop
				Result.put (Directory.current_working + path.item)
			end
		end

	total_file_size: INTEGER
		do
			across file_set as path loop
				Result := Result + OS.File_system.file_byte_count (path.item)
			end
		end

feature {NONE} -- Internal attributes

	file_checksums: EL_HASH_TABLE [NATURAL, EL_FILE_PATH]

	file_set: EL_HASH_SET [EL_FILE_PATH]

feature {NONE} -- Factory

	new_empty_file_tree: HASH_TABLE [ARRAY [READABLE_STRING_GENERAL], EL_DIR_PATH]
		do
			create Result.make (0)
		end

	new_file_set: EL_HASH_SET [EL_FILE_PATH]
		local
			file_tree: like new_file_tree; l_step: ZSTRING
			data_dir: EL_DIR_PATH
		do
			file_tree := new_file_tree
			create Result.make_equal (file_tree.count * 2)
			across file_tree as last_steps loop
				data_dir := Work_area_dir.joined_dir_path (last_steps.key)
				across last_steps.item as step loop
					create l_step.make_from_general (step.item)
					Result.put (data_dir + l_step)
				end
			end
		end

	new_file_tree: like new_empty_file_tree
		deferred
		end

feature {NONE} -- Constants

	Current_work_area_dir: EL_DIR_PATH
		once
			Result := Directory.current_working.joined_dir_path (Work_area_dir)
		end
end
