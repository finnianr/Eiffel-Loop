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
	date: "2022-01-18 21:52:18 GMT (Tuesday 18th January 2022)"
	revision: "12"

class
	VTD_XML_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_SUB_APPLICATION [
		JOBSERVE_SEARCHER_TEST_SET,
		VTD_XML_TEST_SET,
		XML_TO_PYXIS_CONVERTER_TEST_SET
	]
		redefine
			version
		end

create
	make

feature {NONE} -- Constants

	Version: INTEGER = 2
end