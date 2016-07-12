note
	description: "Summary description for {TESTABLE_JAVA_APPLICATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 20:23:43 GMT (Friday 8th July 2016)"
	revision: "4"

deferred class
	TESTABLE_JAVA_APPLICATION

inherit
	EL_SUB_APPLICATION
		undefine
			option_name, new_lio, new_log_manager
		end

	EL_REGRESSION_TESTING_APPLICATION

	EL_MODULE_JAVA_PACKAGES

end
