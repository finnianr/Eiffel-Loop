note
	description: "Finalized executable tests for library [./library/pyxis-scan.html pyxis-scan.ecf]"
	notes: "[
		Command option: `-pyxis_scan_autotest'
		
		**Test Sets**
		
			[$source PYXIS_TO_XML_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-19 14:30:05 GMT (Wednesday 19th January 2022)"
	revision: "21"

class
	PYXIS_SCAN_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_SUB_APPLICATION [PYXIS_TO_XML_TEST_SET]
		redefine
			log_filter_set
		end

create
	make

feature {NONE} -- Implementation

	compiled: TUPLE [
		EL_BINARY_ENCODED_DOCUMENT_SCANNER,
		EL_BINARY_ENCODED_PARSE_EVENT_TYPE,
		EL_FILE_MANIFEST_GENERATOR,
		EL_PYXIS_RESOURCE_SET,
		EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS,
		EL_DOCUMENT_NODE_LOGGER,
		EL_XHTML_WORD_COUNTER,
		EL_XML_NODE_EVENT_GENERATOR,
		EL_DOCUMENT_CRC_32_HANDLER
	]
		do
			create Result
		end

	log_filter_set: EL_LOG_FILTER_SET [
		like Current, PYXIS_TO_XML_TEST_SET
	]
		do
			create Result.make
		end

end