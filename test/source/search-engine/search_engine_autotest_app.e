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
	date: "2020-02-14 13:58:32 GMT (Friday 14th February 2020)"
	revision: "2"

class
	SEARCH_ENGINE_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	test_type: TUPLE [SEARCH_ENGINE_TEST_SET]
		do
			create Result
		end

	test_types_all: TUPLE [SEARCH_ENGINE_TEST_SET, ENCRYPTED_SEARCH_ENGINE_TEST_SET]
		do
			create Result
		end
end
