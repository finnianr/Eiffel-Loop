note
	description: "Undefine pattern counter test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-18 11:14:35 GMT (Tuesday 18th February 2020)"
	revision: "4"

class
	UNDEFINE_PATTERN_COUNTER_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_DIRECTORY

	EL_MODULE_LOG

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("command", agent test_command)
		end

feature -- Tests

	test_command
		local
			command: TEST_UNDEFINE_PATTERN_COUNTER_COMMAND
		do
			log.enter ("test_command")
			create command.make ("test-data/publisher-manifest.pyx", create {EL_DIR_PATH_ENVIRON_VARIABLE})
			command.execute

			assert ("3 classes match", command.class_count = 3)
			log.exit
		end
end
