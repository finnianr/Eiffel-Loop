note
	description: "Regression autotest sub application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-15 10:28:21 GMT (Tuesday 15th September 2020)"
	revision: "4"

deferred class
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION [EQA_TYPES -> TUPLE create default_create end]

inherit
	EL_AUTOTEST_SUB_APPLICATION [EQA_TYPES]
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