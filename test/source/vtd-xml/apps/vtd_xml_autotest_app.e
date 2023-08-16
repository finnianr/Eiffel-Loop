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
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-27 6:43:55 GMT (Thursday 27th July 2023)"
	revision: "16"

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
		EL_C_STRING_8_BE, EL_C_STRING_8_LE,
		EL_C_STRING_16, EL_C_STRING_16_BE, EL_C_STRING_16_LE,
		EL_C_STRING_32_BE, EL_C_STRING_32_LE,
		EL_C_UTF8_STRING_8, EL_MODULE_C_DECODER
	]
		-- from C-language-interface.ecf
		do
			create Result
		end
end