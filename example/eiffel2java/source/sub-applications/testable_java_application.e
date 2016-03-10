note
	description: "Summary description for {TESTABLE_JAVA_APPLICATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 11:47:56 GMT (Monday 24th June 2013)"
	revision: "2"

deferred class
	TESTABLE_JAVA_APPLICATION

inherit
	EL_SUB_APPLICATION
		undefine
			option_name
		end

	EL_TESTABLE_APPLICATION

	EL_MODULE_JAVA_PACKAGES

feature {NONE} -- Constants

	Eiffel_loop_dir: EL_DIR_PATH
		once
			Result := Execution.variable_dir_path ("EIFFEL_LOOP")
		end


end
