note
	description: "Finalized executable tests for library [./library/pyxis-scan.html pyxis-scan.ecf]"
	notes: "[
		Command option: `-pyxis_scan_autotest'
		
		**Test Sets**
		
			${PYXIS_TO_XML_TEST_SET}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "27"

class
	PYXIS_SCAN_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_APPLICATION [PYXIS_TO_XML_TEST_SET]
		redefine
			log_filter_set
		end

create
	make

feature {NONE} -- Implementation

	compiled: TUPLE [
		EL_BINARY_ENCODED_DOCUMENT_SCANNER,
		EL_BINARY_ENCODED_PARSE_EVENT_TYPE,
		EL_BUILDER_OBJECT_FACTORY [EL_BUILDABLE_FROM_NODE_SCAN, EL_BUILDABLE_FROM_NODE_SCAN, TUPLE],

		EL_FILE_MANIFEST_GENERATOR,
		EL_FILE_PERSISTENT_BUILDABLE_FROM_PYXIS,
		EL_PYXIS_RESOURCE_SET, EL_PYXIS_XPATH_SET_COMPILER, EL_PYXIS_TREE_COMPILER,
		EL_PYXIS_OBJECT_IMPORTER [EL_REFLECTIVELY_SETTABLE],
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