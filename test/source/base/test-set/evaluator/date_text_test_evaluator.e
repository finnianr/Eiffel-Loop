note
	description: "Evaluates tests in [$source DATE_TEXT_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-30 20:20:14 GMT (Thursday 30th January 2020)"
	revision: "4"

class
	DATE_TEXT_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [DATE_TEXT_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("formatted_date",								agent item.test_formatted_date)
			test ("from_ISO_8601_formatted",					agent item.test_from_iso_8601_formatted)
			test ("from_canonical_iso_8601_formatted",	agent item.test_from_canonical_iso_8601_formatted)
		end

end
