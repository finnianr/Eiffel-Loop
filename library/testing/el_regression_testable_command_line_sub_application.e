note
	description: "Summary description for {EL_TESTABLE_UNIVERSAL_SUB_APPLICATTION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-16 10:17:20 GMT (Monday 16th October 2017)"
	revision: "8"

deferred class
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [C -> EL_COMMAND]

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [C]
		rename
			initialize as normal_initialize,
			run as normal_run
		undefine
			new_lio, new_log_manager, log_filter_list
		end

	EL_REGRESSION_TESTABLE_SUB_APPLICATION
		select
			initialize, run
		end

end
