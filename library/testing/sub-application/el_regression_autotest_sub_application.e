note
	description: "Regression autotest sub application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-31 13:22:25 GMT (Friday 31st January 2020)"
	revision: "1"

deferred class
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION
		redefine
			new_lio, new_log_manager
		end

feature {NONE} -- Implementation

	new_lio: EL_LOGGABLE
		do
			create {EL_TESTING_CONSOLE_ONLY_LOG} Result.make
		end

	new_log_manager: EL_TESTING_LOG_MANAGER
		do
			create Result.make (is_logging_active, Log_output_directory)
		end
end
