note
	description: "Undefine pattern counter test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 9:57:40 GMT (Monday 1st July 2019)"
	revision: "3"

class
	UNDEFINE_PATTERN_COUNTER_TEST_SET

inherit
	EQA_TEST_SET

	EL_MODULE_DIRECTORY

	EL_MODULE_LOG

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
