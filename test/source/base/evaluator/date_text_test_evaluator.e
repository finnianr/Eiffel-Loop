note
	description: "Date text test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-23 14:58:38 GMT (Thursday 23rd January 2020)"
	revision: "3"

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
