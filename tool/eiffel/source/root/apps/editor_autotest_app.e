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
	date: "2020-09-15 10:26:15 GMT (Tuesday 15th September 2020)"
	revision: "3"

class
	EDITOR_AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION [TUPLE [
		FEATURE_EDITOR_COMMAND_TEST_SET,
		NOTE_EDITOR_TEST_SET
	]]
		redefine
			visible_types
		end

create
	make

feature {NONE} -- Implementation

	visible_types: TUPLE [FEATURE_EDITOR_COMMAND]
		do
			create Result
		end

end