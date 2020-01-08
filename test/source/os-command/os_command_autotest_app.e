note
	description: "Sub-application to aid development of AutoTest classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 14:01:10 GMT (Wednesday 8th January 2020)"
	revision: "61"

class
	OS_COMMAND_AUTOTEST_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

--	Tests that still need an evaluator
	compile: TUPLE [
		AUDIO_COMMAND_TEST_SET,
		FILE_TREE_INPUT_OUTPUT_COMMAND_TEST_SET,
		OS_COMMAND_TEST_SET
	]

	evaluator_type, evaluator_types_all: TUPLE [FILE_AND_DIRECTORY_TEST_EVALUATOR]
		do
			create Result
		end

end
