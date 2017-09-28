note
	description: "[
		Test using a set of files copied from `test-data' directory
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-07-23 11:33:30 GMT (Sunday 23rd July 2017)"
	revision: "1"

deferred class
	EL_TEST_DATA_TEST_SET

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

feature {NONE} -- Events

	on_clean
		do
			reset_work_area
		end

	on_prepare
		do
			reset_work_area
			OS.copy_tree (test_data_root_dir.joined_dir_path (relative_dir), workarea_root_dir)
			work_dir := workarea_root_dir.joined_dir_path (relative_dir.base)
		end

feature {NONE} -- Implementation

	reset_work_area
			-- create an empty work area
		do
			if workarea_root_dir.exists then
				OS.delete_tree (workarea_root_dir)
				reset_work_area
			else
				OS.File_system.make_directory (workarea_root_dir)
			end
		end

	relative_dir: EL_DIR_PATH
		deferred
		end

feature {NONE} -- Internal attributes

	work_dir: EL_DIR_PATH
		-- working test files directory

feature {NONE} -- Constants

	test_data_root_dir: EL_DIR_PATH
		once
			Result := "test-data"
		end

	workarea_root_dir: EL_DIR_PATH
		once
			Result := "workarea"
		end

end
