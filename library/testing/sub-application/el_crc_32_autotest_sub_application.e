note
	description: "[
		[$source EL_AUTOTEST_SUB_APPLICATION] object with support for test sets conforming
		to [$source EL_CRC_32_EQA_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-18 22:01:02 GMT (Tuesday 18th January 2022)"
	revision: "5"

deferred class
	EL_CRC_32_AUTOTEST_SUB_APPLICATION [EQA_TYPES -> TUPLE create default_create end]

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
			if version = 1 then
				-- legacy version
				create {EL_TESTING_CONSOLE_AND_FILE_LOG} Result.make -- Normal logging object
			else
				-- recommmended version
				create {EL_CRC_32_CONSOLE_AND_FILE_LOG} Result.make -- Normal logging object
			end
		end

	new_log_manager: EL_LOG_MANAGER
		do
			if version = 1 then
				-- legacy version
				create {EL_TESTING_LOG_MANAGER} Result.make (is_logging_active, Log_output_directory)
			else
				-- recommmended version
				create {EL_CRC_32_LOG_MANAGER} Result.make (is_logging_active, Log_output_directory)
			end
		end

	version: INTEGER
		do
			Result := 1
		ensure
			valid_result: Result = 1 or Result = 2
		end
end