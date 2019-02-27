note
	description: "Sub-application to aid development of AutoTest classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-27 13:29:08 GMT (Wednesday 27th February 2019)"
	revision: "39"

class
	AUTOTEST_DEVELOPMENT_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION

create
	make

feature {NONE} -- Constants

	Evaluator_types: TUPLE [SEARCH_ENGINE_TEST_EVALUATOR]
		once
			create Result
		end

	Evaluator_types_all: TUPLE [
		HTTP_CONNECTION_TEST_EVALUATOR, SEARCH_ENGINE_TEST_EVALUATOR, ENCRYPTED_SEARCH_ENGINE_TEST_EVALUATOR
	]
		once
			create Result
		end

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{AUTOTEST_DEVELOPMENT_APP}, All_routines],
				[{HTTP_CONNECTION_TEST_SET}, All_routines]
			>>
		end

end
