note
	description: "Regression autotest sub application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-02 17:53:16 GMT (Sunday 2nd February 2020)"
	revision: "2"

deferred class
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION
		redefine
			new_log, new_lio, new_log_manager
		end

feature {NONE} -- Implementation

	new_lio: EL_LOGGABLE
		do
			Result := Once_log
		end

	new_log: EL_LOGGABLE
		do
			create {EL_TESTING_CONSOLE_AND_FILE_LOG} Result.make -- Normal logging object
		end

	new_log_manager: EL_TESTING_LOG_MANAGER
		do
			create Result.make (is_logging_active, Log_output_directory)
		end
end
