note
	description: "Test using test files in $EIFFEL_LOOP/projects.data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-18 9:24:46 GMT (Saturday 18th June 2016)"
	revision: "5"

class
	PROJECTS_DATA_TEST_SET

inherit
	EQA_TEST_SET
		rename
			file_system as eqa_file_system
		export
			{EL_SUB_APPLICATION} clean
		redefine
			on_prepare, on_clean
		end

	EL_MODULE_LOG
		undefine
			default_create
		end

	EL_MODULE_FILE_SYSTEM
		undefine
			default_create
		end

	EL_MODULE_EXECUTION_ENVIRONMENT
		undefine
			default_create
		end

feature {NONE} -- Events

	on_prepare
		do
			Execution_environment.push_current_working (Execution_environment.variable_dir_path ("EIFFEL_LOOP"))
		end

	on_clean
		do
			Execution_environment.pop_current_working
		end

feature {NONE} -- Constants

	Project_data_dir: EL_DIR_PATH
		once
			Result := "projects.data"
		end

	Work_area_dir: EL_DIR_PATH
		once
			Result := Project_data_dir.joined_dir_path ("workarea")
		end
end
