note
	description: "Evaluates tests in [$source VTD_XML_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 15:00:26 GMT (Thursday 6th February 2020)"
	revision: "15"

class
	VTD_XML_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [VTD_XML_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("query_processing_instruction",	agent item.test_query_processing_instruction)
			test ("cd_catalog_xpath_query",			agent item.test_cd_catalog_xpath_query)
			test ("svg_xpath_query",					agent item.test_svg_xpath_query)
			test ("bioinfo_xpath_query_1",			agent item.test_bioinfo_xpath_query)
		end

end
