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
	date: "2025-03-02 10:43:55 GMT (Sunday 2nd March 2025)"
	revision: "24"

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
		EL_HYPERLINK,

		EL_XHTML_STRING_LIST,
		EL_XHTML_UTF_8_SOURCE,
		EL_XHTML_BODY,

		TB_XHTML_BODY_LINES,

		XML_TAG_LIST, XML_LIST_ELEMENT, XML_TEXT_NODE,
		XML_PARENT_TAG_LIST
	]
		do
			create Result
		end

end