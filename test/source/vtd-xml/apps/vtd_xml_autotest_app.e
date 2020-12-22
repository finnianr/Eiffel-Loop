note
	description: "Finalized executable tests for library [./library/vtd-xml.html vtd-xml.ecf]"
	notes: "[
		Command option: `-vtd_xml_autotest'
		
		**Test Sets**
		
			[$source VTD_XML_TEST_SET]
			[$source XML_TO_PYXIS_CONVERTER_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-21 15:26:25 GMT (Monday 21st December 2020)"
	revision: "9"

class
	VTD_XML_AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION [
		VTD_XML_TEST_SET, XML_TO_PYXIS_CONVERTER_TEST_SET
	]

create
	make

end