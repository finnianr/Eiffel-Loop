note
	description: "Finalized executable tests for library [./library/search-engine.html search-engine.ecf]"
	notes: "[
		Command option: `-search_engine_autotest'
		
		**Test Sets**
		
			[$source ENCRYPTED_SEARCH_ENGINE_TEST_SET]
			[$source SEARCH_ENGINE_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-03 12:02:10 GMT (Sunday 3rd January 2021)"
	revision: "5"

class
	SEARCH_ENGINE_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [
		ENCRYPTED_SEARCH_ENGINE_TEST_SET,
		SEARCH_ENGINE_TEST_SET
	]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [
		EL_SEARCH_TERM_PARSER [EL_WORD_SEARCHABLE]
	]
		do
			create Result
		end
end