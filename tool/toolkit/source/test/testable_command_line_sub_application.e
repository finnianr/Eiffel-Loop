note
	description: "Summary description for {TESTABLE_COMMAND_LINE_SUB_APPLICATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TESTABLE_COMMAND_LINE_SUB_APPLICATION [C -> EL_COMMAND create default_create end]

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATION [C]

	EL_EIFFEL_LOOP_TEST_CONSTANTS
end
