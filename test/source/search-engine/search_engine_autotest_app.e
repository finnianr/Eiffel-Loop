note
	description: "Search engine autotest app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 13:42:24 GMT (Wednesday 8th January 2020)"
	revision: "1"

class
	SEARCH_ENGINE_AUTOTEST_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	evaluator_type: TUPLE [SEARCH_ENGINE_TEST_EVALUATOR]
		do
			create Result
		end

	evaluator_types_all: TUPLE [
		SEARCH_ENGINE_TEST_EVALUATOR, ENCRYPTED_SEARCH_ENGINE_TEST_EVALUATOR
	]
		do
			create Result
		end
end
