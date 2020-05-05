note
	description: "Finalized executable tests for library [./library/text-formats.html text-formats.ecf]"
	notes: "[
		Command option: `-text_formats_autotest'
		
		**Test Sets**
		
			[$source COMMA_SEPARATED_IMPORT_TEST_SET]
			[$source JSON_NAME_VALUE_LIST_TEST_SET]
			[$source SETTABLE_FROM_JSON_STRING_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-05 11:31:21 GMT (Tuesday 5th May 2020)"
	revision: "4"

class
	TEXT_FORMATS_AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	test_type: TUPLE [COMMA_SEPARATED_IMPORT_TEST_SET]
		do
			create Result
		end

	test_types_all: TUPLE [
		COMMA_SEPARATED_IMPORT_TEST_SET,
		JSON_NAME_VALUE_LIST_TEST_SET,
		SETTABLE_FROM_JSON_STRING_TEST_SET,
		XML_ESCAPER_TEST_SET
	]
		do
			create Result
		end

end
