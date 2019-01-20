note
	description: "Eiffel loop test constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:50 GMT (Saturday 19th May 2018)"
	revision: "5"

class
	EL_EIFFEL_LOOP_TEST_CONSTANTS

inherit
	EL_MODULE_EXECUTION_ENVIRONMENT

feature {NONE} -- Constants

	Eiffel_loop_dir: EL_DIR_PATH
			--
		once
			Result := Execution.variable_dir_path ("EIFFEL_LOOP")
		end

	Test_data_dir: EL_DIR_PATH
			--
		once
			Result := Eiffel_loop_dir.joined_dir_path ("projects.data")
		end

end
