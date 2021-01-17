note
	description: "Undefine pattern counter test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-17 16:35:48 GMT (Sunday 17th January 2021)"
	revision: "7"

class
	UNDEFINE_PATTERN_COUNTER_TEST_SET

inherit
	EL_EQA_REGRESSION_TEST_SET

	EL_MODULE_DIRECTORY

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("command", agent test_command)
		end

feature -- Tests

	test_command
		do
			do_test ("count_pattern", 138268884, agent count_pattern, [])
		end

feature {NONE} -- Implementation

	count_pattern
		local
			command: UNDEFINE_PATTERN_COUNTER_COMMAND
		do
			create command.make ("test-data/base-manifest.pyx", create {EL_DIR_PATH_ENVIRON_VARIABLE})
			command.execute

			assert ("3 classes match", command.class_count = 3)
		end
end