note
	description: "Evaluates tests in [$source VTD_XML_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-31 12:05:01 GMT (Friday 31st January 2020)"
	revision: "13"

class
	VTD_XML_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [VTD_XML_TEST_SET]
		rename
			lio as log
		undefine
			new_lio, log
		end

	EL_MODULE_LOG
		select
			log
		end

feature {NONE} -- Implementation

	do_tests
		do
			test ("bioinfo_xpath_query_1",			agent item.test_bioinfo_xpath_query)
--			test ("delete_content_with_action",	agent item.test_delete_content_with_action)
--			test ("delete_with_action",			agent item.test_delete_with_action)
--			test ("read_directories",				agent item.test_read_directories)
--			test ("read_directory_files",			agent item.test_read_directory_files)
		end


end
