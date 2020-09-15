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
	date: "2020-09-15 10:24:19 GMT (Tuesday 15th September 2020)"
	revision: "7"

class
	TEXT_FORMATS_AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION [TUPLE [
		COMMA_SEPARATED_IMPORT_TEST_SET,
		JSON_NAME_VALUE_LIST_TEST_SET,
		SETTABLE_FROM_JSON_STRING_TEST_SET,
		XML_ESCAPER_TEST_SET
	]]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [EL_XHTML_STRING_LIST, EL_XHTML_UTF_8_SOURCE]
		do
			create Result
		end

end