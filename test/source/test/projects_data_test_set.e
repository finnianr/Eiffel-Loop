note
	description: "Summary description for {PROJECT_DATA_TEST_SET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-18 12:41:55 GMT (Monday 18th January 2016)"
	revision: "7"

class
	PROJECTS_DATA_TEST_SET

inherit
	EQA_TEST_SET
		rename
			file_system as eqa_file_system
		end

	EL_MODULE_LOG
		undefine
			default_create
		end

	EL_MODULE_FILE_SYSTEM
		undefine
			default_create
		end

feature {NONE} -- Constants

	Project_data_dir: EL_DIR_PATH
		local
			steps: EL_PATH_STEPS
		once
			steps := << "$EIFFEL_LOOP", "projects.data" >>
			Result := steps.expanded_path
		end
end
