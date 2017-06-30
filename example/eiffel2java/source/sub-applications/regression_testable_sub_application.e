note
	description: "Summary description for {TESTABLE_JAVA_APPLICATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 14:11:07 GMT (Thursday 29th June 2017)"
	revision: "3"

deferred class
	REGRESSION_TESTABLE_SUB_APPLICATION

inherit
	EL_REGRESSION_TESTABLE_SUB_APPLICATION
		undefine
			option_name
		end

	EL_MODULE_JAVA_PACKAGES

	EL_MODULE_OS

feature {NONE} -- Constants

	Eiffel_loop_dir: EL_DIR_PATH
			--
		once
			Result := Execution.variable_dir_path ("EIFFEL_LOOP")
		end
end
