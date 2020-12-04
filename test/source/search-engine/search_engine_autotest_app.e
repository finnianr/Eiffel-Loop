note
	description: "Finalized executable tests for library [./library/search-engine.html search-engine.ecf]"
	notes: "[
		Command option: `-search_engine_autotest'
		
		**Test Sets**
		
			[$source SEARCH_ENGINE_TEST_SET]
			[$source ENCRYPTED_SEARCH_ENGINE_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-03 10:39:28 GMT (Thursday 3rd December 2020)"
	revision: "4"

class
	SEARCH_ENGINE_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [SEARCH_ENGINE_TEST_SET, ENCRYPTED_SEARCH_ENGINE_TEST_SET]

create
	make

end