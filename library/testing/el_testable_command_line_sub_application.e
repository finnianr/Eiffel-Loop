note
	description: "Summary description for {EL_TESTABLE_UNIVERSAL_SUB_APPLICATTION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-30 5:02:19 GMT (Tuesday 30th May 2017)"
	revision: "3"

deferred class
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATION [C -> EL_COMMAND create default_create end]

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [C]
		undefine
			initialize, run, new_lio, new_log_manager
		end

	EL_REGRESSION_TESTING_APPLICATION

feature {NONE} -- Initiliazation

	normal_initialize
			--
		do
			create command
			create specs.make_from_array (argument_specs)
			set_operands
			if Is_test_mode then
				Console.show ({EL_REGRESSION_TESTING_ROUTINES})
			end
			if not has_invalid_argument then
				make_command
			end
		end

	normal_run
		do
			command.execute
		end

end
