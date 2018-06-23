note
	description: "[
		Provides a way to add regression tests to command line apps conforming to `[$source EL_COMMAND_LINE_SUB_APPLICATION]'
		by using the regression testing routines in class `[$source EL_MODULE_TEST]'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-19 10:45:39 GMT (Tuesday 19th June 2018)"
	revision: "10"

deferred class
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [C -> EL_COMMAND]

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [C]
		rename
			initialize as normal_initialize,
			run as normal_run
		undefine
			new_log_manager, new_lio, new_log_filter_list
		end

	EL_REGRESSION_TESTABLE_SUB_APPLICATION
		select
			initialize, run
		end

end
