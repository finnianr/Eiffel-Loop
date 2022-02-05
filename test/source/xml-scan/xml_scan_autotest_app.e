note
	description: "Finalized executable tests for library [./library/xml-scan.html xml-scan.ecf]"
	notes: "[
		Command option: `-xml_scan_autotest'
		
		**Test Sets**
		
			[$source CREATEABLE_FROM_XPATH_MATCH_EVENTS_TEST_SET]
			[$soure DOCUMENT_NODE_STRING_TEST_SET]
			[$source OBJECT_BUILDER_TEST_SET]
			[$source REFLECTIVE_BUILDABLE_AND_STORABLE_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 14:52:16 GMT (Saturday 5th February 2022)"
	revision: "22"

class
	XML_SCAN_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_APPLICATION [
		CREATEABLE_FROM_XPATH_MATCH_EVENTS_TEST_SET,
		DOCUMENT_NODE_STRING_TEST_SET,
		OBJECT_BUILDER_TEST_SET,
		REFLECTIVE_BUILDABLE_AND_STORABLE_TEST_SET
	]
		redefine
			log_filter_set
		end

create
	make

feature {NONE} -- Implementation

	compiled: TUPLE [
		EL_BINARY_ENCODED_DOCUMENT_SCANNER,
		EL_BINARY_ENCODED_PARSE_EVENT_TYPE,
		EL_DOCUMENT_NODE_LOGGER,
		EL_DOCUMENT_CRC_32_HANDLER,
		EL_EIF_OBJ_TEXT_TABLE_CONTEXT,
		EL_PYXIS_RESOURCE_SET,
		EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS,
		EL_XHTML_WORD_COUNTER,
		EL_XML_NODE_EVENT_GENERATOR
	]
		do
			create Result
		end

	log_filter_set: EL_LOG_FILTER_SET [
		like Current,
		OBJECT_BUILDER_TEST_SET,
		CREATEABLE_FROM_XPATH_MATCH_EVENTS_TEST_SET,
		REFLECTIVE_BUILDABLE_AND_STORABLE_TEST_SET,

		BIOINFORMATIC_COMMANDS,
		BIOINFO_COMMAND,
		CONTAINER_PARAMETER,
		TITLE_PARAMETER,
		URL_PARAMETER,
		RULES_LIST_PARAMETER,
		DATA_PARAMETER,
		BOOLEAN_PARAMETER,
		INTEGER_PARAMETER,
		REAL_PARAMETER,
		CHOICE_PARAMETER,
		INTEGER_RANGE_LIST_PARAMETER,
		REAL_RANGE_LIST_PARAMETER,
		STRING_LIST_PARAMETER
	]
		do
			create Result.make
		end

end