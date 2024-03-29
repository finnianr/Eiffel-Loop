note
	description: "[
		${EL_AUTOTEST_APPLICATION} object with support for test sets conforming
		to ${EL_CRC_32_TESTABLE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "11"

deferred class
	EL_CRC_32_AUTOTEST_APPLICATION [EQA_TYPES -> TUPLE create default_create end]

inherit
	EL_AUTOTEST_APPLICATION [EQA_TYPES]
		redefine
			new_log, new_lio, new_log_manager
		end

feature {NONE} -- Implementation

	new_lio: EL_LOGGABLE
		do
			Result := Once_log
		end

	new_log: EL_CRC_32_CONSOLE_AND_FILE_LOG
		do
			create Result.make -- Normal logging object
		end

	new_log_manager: EL_CRC_32_LOG_MANAGER
		do
			create Result.make (is_logging_active, Log_output_directory)
		end

end