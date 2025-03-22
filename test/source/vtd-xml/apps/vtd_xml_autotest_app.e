note
	description: "Finalized executable tests for library [./library/vtd-xml.html vtd-xml.ecf]"
	notes: "[
		Command option: `-vtd_xml_autotest'
		
		**Test Sets**
		
			${JOBSERVE_SEARCHER_TEST_SET}
			${VTD_XML_TEST_SET}
			${XML_TO_PYXIS_CONVERTER_TEST_SET}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-21 15:16:06 GMT (Friday 21st March 2025)"
	revision: "19"

class
	VTD_XML_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_APPLICATION [
		JOBSERVE_SEARCHER_TEST_SET,
		VTD_XML_TEST_SET,
		XML_TO_PYXIS_CONVERTER_TEST_SET
	]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [
		EL_LIST_FROM_XML [EL_XML_CREATEABLE_OBJECT],
		EL_XML_CREATEABLE_OBJECT,
		EL_XML_FILE_PERSISTENT
	]
		-- from C-language-interface.ecf
		do
			create Result
		end
end