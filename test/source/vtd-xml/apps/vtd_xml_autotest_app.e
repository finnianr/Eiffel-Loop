note
	description: "Finalized executable tests for library [./library/vtd-xml.html vtd-xml.ecf]"
	notes: "[
		Command option: `-vtd_xml_autotest'
		
		**Test Sets**
		
			[$source JOBSERVE_SEARCHER_TEST_SET]
			[$source VTD_XML_TEST_SET]
			[$source XML_TO_PYXIS_CONVERTER_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-19 14:29:35 GMT (Wednesday 19th January 2022)"
	revision: "13"

class
	VTD_XML_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_SUB_APPLICATION [
		JOBSERVE_SEARCHER_TEST_SET,
		VTD_XML_TEST_SET,
		XML_TO_PYXIS_CONVERTER_TEST_SET
	]

create
	make

end