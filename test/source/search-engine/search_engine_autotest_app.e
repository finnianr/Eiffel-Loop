note
	description: "Finalized executable tests for library [./library/search-engine.html search-engine.ecf]"
	notes: "[
		Command option: `-search_engine_autotest'
		
		**Test Sets**
		
			${ENCRYPTED_SEARCH_ENGINE_TEST_SET}
			${SEARCH_ENGINE_TEST_SET}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "8"

class
	SEARCH_ENGINE_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [
		ENCRYPTED_SEARCH_ENGINE_TEST_SET,
		SEARCH_ENGINE_TEST_SET
	]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [
		EL_SEARCH_ENGINE [EL_WORD_SEARCHABLE, EL_SEARCH_TERM_PARSER [EL_WORD_SEARCHABLE]]
	]
		do
			create Result
		end
end