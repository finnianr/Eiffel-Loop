note
	description: "Convenience class to develop AutoTest classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-14 18:22:24 GMT (Thursday 14th February 2019)"
	revision: "21"

class
	AUTOTEST_DEVELOPMENT_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	evalator_types: ARRAY [like Type_evaluator]
		do
			Result := <<
				{REPOSITORY_PUBLISHER_TEST_EVALUATOR},
				{REPOSITORY_SOURCE_LINK_EXPANDER_TEST_EVALUATOR}
			>>
		end

feature {NONE} -- Tests

	tuple: TUPLE [NOTE_EDITOR_TEST_SET, UNDEFINE_PATTERN_COUNTER_TEST_SET]
		do
			create Result
		end


feature {NONE} -- Constants

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{AUTOTEST_DEVELOPMENT_APP}, All_routines],
				[{EIFFEL_CONFIGURATION_FILE}, All_routines],
				[{EIFFEL_CONFIGURATION_INDEX_PAGE}, All_routines],
				[{NOTE_EDITOR_TEST_SET}, All_routines],
				[{REPOSITORY_PUBLISHER_TEST_SET}, All_routines],
				[{REPOSITORY_SOURCE_LINK_EXPANDER_TEST_SET}, All_routines],
				[{UNDEFINE_PATTERN_COUNTER_TEST_SET}, All_routines],
				[{TEST_UNDEFINE_PATTERN_COUNTER_COMMAND}, All_routines]
			>>
		end

end
