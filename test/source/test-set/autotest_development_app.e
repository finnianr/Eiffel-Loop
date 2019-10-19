note
	description: "Sub-application to aid development of AutoTest classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-02 10:46:09 GMT (Wednesday   2nd   October   2019)"
	revision: "45"

class
	AUTOTEST_DEVELOPMENT_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION

create
	make

feature {NONE} -- Constants

	Evaluator_types: TUPLE [UNDERBIT_ID3_TAG_INFO_TEST_EVALUATOR]
		once
			create Result
		end

	Evaluator_types_all: TUPLE [
		AMAZON_INSTANT_ACCESS_TEST_EVALUATOR,
		HTTP_CONNECTION_TEST_EVALUATOR,
		SEARCH_ENGINE_TEST_EVALUATOR,
		ENCRYPTED_SEARCH_ENGINE_TEST_EVALUATOR,
		PAYPAL_TEST_EVALUATOR,
		REFLECTIVE_BUILDABLE_AND_STORABLE_TEST_EVALUATOR,
		UNDERBIT_ID3_TAG_INFO_TEST_EVALUATOR,
		ZSTRING_TEST_EVALUATOR
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
