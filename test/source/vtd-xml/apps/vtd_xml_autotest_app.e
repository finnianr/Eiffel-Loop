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
	date: "2020-10-18 12:59:39 GMT (Sunday 18th October 2020)"
	revision: "8"

class
	VTD_XML_AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION [
		VTD_XML_TEST_SET,
		XML_TO_PYXIS_CONVERTER_TEST_SET
	]

create
	make

end