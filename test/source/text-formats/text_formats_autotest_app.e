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
	date: "2021-03-04 17:33:50 GMT (Thursday 4th March 2021)"
	revision: "9"

class
	TEXT_FORMATS_AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION [
		COMMA_SEPARATED_IMPORT_TEST_SET,
		JSON_NAME_VALUE_LIST_TEST_SET,
		SETTABLE_FROM_JSON_STRING_TEST_SET,
		XML_ESCAPER_TEST_SET
	]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [EL_XHTML_STRING_LIST, EL_XHTML_UTF_8_SOURCE, EL_XML_TAG_LIST, EL_XML_PARENT_TAG_LIST]
		do
			create Result
		end

end