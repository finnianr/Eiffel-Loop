note
	description: "Finalized executable tests for sub-applications"
	notes: "[
		Command option: `-editor_autotest'
		
		**Test Sets**
		
			[$source FEATURE_EDITOR_COMMAND_TEST_SET]
			[$source NOTE_EDITOR_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-15 10:54:25 GMT (Friday 15th May 2020)"
	revision: "2"

class
	EDITOR_AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION
		redefine
			visible_types
		end

create
	make

feature {NONE} -- Implementation

	test_type: TUPLE [NOTE_EDITOR_TEST_SET]
		do
			create Result
		end

	test_types_all: TUPLE [
		FEATURE_EDITOR_COMMAND_TEST_SET,
		NOTE_EDITOR_TEST_SET
	]
		do
			create Result
		end

	visible_types: TUPLE [FEATURE_EDITOR_COMMAND]
		do
			create Result
		end

end
