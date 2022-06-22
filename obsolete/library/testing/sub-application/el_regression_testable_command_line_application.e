note
	description: "[
		Provides a way to add regression tests to command line apps conforming to [$source EL_COMMAND_LINE_APPLICATION]
		by using the regression testing routines in class [$source EL_MODULE_TEST]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 17:26:15 GMT (Saturday 5th February 2022)"
	revision: "20"

deferred class
	EL_REGRESSION_TESTABLE_COMMAND_LINE_APPLICATION [C -> EL_COMMAND]

inherit
	EL_LOGGED_COMMAND_LINE_APPLICATION [C]
		rename
			initialize as normal_initialize,
			log_filter_set as extra_log_filter_set,
			run as normal_run
		undefine
			new_log_manager, new_lio, new_log_filter_set
		redefine
			set_closed_operands
		end

	EL_REGRESSION_TESTABLE_APPLICATION
		undefine
			read_command_options
		redefine
			new_log_filter_set
		select
			initialize, run
		end

feature {NONE} -- Implementation

	new_log_filter_set: EL_LOG_FILTER_SET [TUPLE]
		do
			Result := Precursor {EL_REGRESSION_TESTABLE_APPLICATION}
			if attached {TYPE [EL_MODULE_LOG]} ({C}) as log_type then
				Result.show_all (log_type)
			end
		end

	set_closed_operands
		do
			if not App_option.test then
				Precursor
			end
		end

end


