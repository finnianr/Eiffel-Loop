note
	description: "Undefine pattern counter test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-18 13:35:26 GMT (Monday 18th January 2021)"
	revision: "8"

class
	UNDEFINE_PATTERN_COUNTER_TEST_SET

inherit
	EL_EQA_REGRESSION_TEST_SET
		redefine
			on_prepare
		end

	EL_MODULE_DIRECTORY

	EL_MODULE_EXECUTION_ENVIRONMENT

	EIFFEL_LOOP_TEST_CONSTANTS

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("command", agent test_command)
		end

feature -- Tests

	test_command
		do
			do_test ("count_pattern", 3797839144, agent count_pattern, [])
		end

feature {NONE} -- Event handling

	on_prepare
		do
			Precursor
			-- Renew EIFFEL_LOOP after publisher tests
			Execution_environment.put (new_eiffel_loop_dir, Var_eiffel_loop)
		end

feature {NONE} -- Implementation

	count_pattern
		local
			command: UNDEFINE_PATTERN_COUNTER_COMMAND
		do
			create command.make ("test-data/base-manifest.pyx", create {EL_DIR_PATH_ENVIRON_VARIABLE})
			command.disable_print
			command.execute

			assert ("3 classes match", command.class_count = 3)
		end
end