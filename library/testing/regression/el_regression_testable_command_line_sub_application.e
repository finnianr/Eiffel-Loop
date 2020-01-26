note
	description: "[
		Provides a way to add regression tests to command line apps conforming to [$source EL_COMMAND_LINE_SUB_APPLICATION]
		by using the regression testing routines in class [$source EL_MODULE_TEST]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-26 14:09:21 GMT (Sunday 26th January 2020)"
	revision: "13"

deferred class
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [C -> EL_COMMAND]

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [C]
		rename
			initialize as normal_initialize,
			run as normal_run
		undefine
			new_log_manager, new_lio, new_log_filter_list
		redefine
			set_closed_operands
		end

	EL_REGRESSION_TESTABLE_SUB_APPLICATION
		undefine
			read_command_options
		select
			initialize, run
		end

feature {NONE} -- Implementation

	set_closed_operands
		do
			if not Application_option.test then
				Precursor
			end
		end

end
