note
	description: "[
		Test using a set of text files generated in workarea directory.
		The file data is a unique natural number.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-19 18:13:56 GMT (Friday 19th March 2021)"
	revision: "13"

deferred class
	EL_GENERATED_FILE_DATA_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		redefine
			on_prepare
		end

	EL_MODULE_DIRECTORY

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_FILE_OPEN_ROUTINES

feature {NONE} -- Initialization

	on_prepare
		do
			Precursor
			file_set := new_file_set
			across file_set as path loop
				OS.File_system.make_directory (path.item.parent)
				if attached open (path.item, Write) as file then
					file.put_integer (path.cursor_index)
					file.close
				end
			end
		end

feature {NONE} -- Implementation

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

	file_set: EL_HASH_SET [EL_FILE_PATH]

feature {NONE} -- Factory

	new_empty_file_tree: HASH_TABLE [EL_ZSTRING_LIST, EL_DIR_PATH]
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