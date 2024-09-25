note
	description: "[
		Test using a directory of files copied from `test-data' directory to `workarea'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-25 11:21:56 GMT (Wednesday 25th September 2024)"
	revision: "12"

deferred class
	EL_TEST_DATA_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		export
			{EL_APPLICATION} clean
		redefine
			on_prepare
		end

	EL_MODULE_OS

	EL_MODULE_DIRECTORY

feature {NONE} -- Events

	on_prepare
		do
			Precursor
			OS.copy_tree (Test_data_dir.plus_dir (relative_dir), Workarea_root_dir)
			work_dir := Workarea_root_dir #+ relative_dir.base
		end

feature {NONE} -- Implementation

	relative_dir: DIR_PATH
		deferred
		end

feature {NONE} -- Internal attributes

	work_dir: DIR_PATH
		-- working test files directory

feature {NONE} -- Constants

	Test_data_dir: DIR_PATH
		once
			Result := "test-data"
		end

	Workarea_root_dir: DIR_PATH
		once
			Result := "workarea"
		end

end