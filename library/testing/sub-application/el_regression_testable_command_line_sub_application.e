note
	description: "[
		Provides a way to add regression tests to command line apps conforming to [$source EL_COMMAND_LINE_SUB_APPLICATION]
		by using the regression testing routines in class [$source EL_MODULE_TEST]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-18 12:47:56 GMT (Tuesday 18th February 2020)"
	revision: "15"

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

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{like Current}, All_routines]
			>>
		end

	set_closed_operands
		do
			if not Application_option.test then
				Precursor
			end
		end

end
