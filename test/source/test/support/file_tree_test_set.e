note
	description: "Summary description for {EL_TEST_SET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-25 9:25:59 GMT (Friday 25th December 2015)"
	revision: "7"

deferred class
	FILE_TREE_TEST_SET

inherit
	EQA_TEST_SET
		rename
			file_system as eqa_file_system
		redefine
			on_prepare,
			on_clean
		end

	EL_MODULE_EXECUTION_ENVIRONMENT
		undefine
			default_create
		end

	EL_MODULE_FILE_SYSTEM
		undefine
			default_create
		end

feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do
			project_data_dir := Execution.variable_dir_path ("EIFFEL_LOOP").joined_dir_steps (<< "projects.data" >>)
			workarea_dir := project_data_dir.joined_dir_steps (<< "workarea" >>)
			test_data_dir := workarea_dir.joined_dir_steps (<< directory_name >>)
			File_system.copy_tree (project_data_dir.joined_dir_path (directory_name), workarea_dir)
		end

	on_clean
			-- <Precursor>
		do
			File_system.delete_tree (workarea_dir)
		end

feature {NONE} -- Implementation

	test_path (a_path: ZSTRING): EL_FILE_PATH
		do
			Result := test_data_dir + a_path
		end

	directory_name: STRING
		deferred
		end

	project_data_dir: EL_DIR_PATH

	workarea_dir: EL_DIR_PATH

	test_data_dir: EL_DIR_PATH

end
