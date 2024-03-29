note
	description: "Finalized executable tests for library [./library/text-formats.html text-formats.ecf]"
	notes: "[
		Command option: `-text_formats_autotest'
		
		**Test Sets**
		
			${COMMA_SEPARATED_IMPORT_TEST_SET}
			${DOC_TYPE_TEST_SET}
			${JSON_PARSING_TEST_SET}
			${MARKUP_ESCAPE_TEST_SET}
			${XML_TEST_SET}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "23"

class
	TEXT_FORMATS_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_APPLICATION [
		COMMA_SEPARATED_IMPORT_TEST_SET,
		DOC_TYPE_TEST_SET,
		JSON_PARSING_TEST_SET,
		MARKUP_ESCAPE_TEST_SET,
		XML_TEST_SET
	]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [
		EL_HTML_META_VALUE_READER [EL_HTML_META_VALUES],
		EL_XHTML_STRING_LIST,
		EL_XHTML_UTF_8_SOURCE,
		XML_TAG_LIST, XML_LIST_ELEMENT, XML_TEXT_NODE,
		XML_PARENT_TAG_LIST,
		EL_DOC_TYPE
	]
		do
			create Result
		end

end