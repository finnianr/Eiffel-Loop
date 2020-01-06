note
	description: "Developer tests for AIA classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-05 14:01:34 GMT (Sunday 5th January 2020)"
	revision: "58"

class
	AMAZON_INSTANT_ACCESS_TEST_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION
		undefine
			Build_info
		end

	EL_EIFFEL_LOOP_TEST_CONSTANTS

create
	make

feature {NONE} -- Implementation

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{AMAZON_INSTANT_ACCESS_TEST_APP}, All_routines]
			>>
		end

feature {NONE} -- Constants

	Evaluator_types: TUPLE [AMAZON_INSTANT_ACCESS_TEST_EVALUATOR]
		once
			create Result
		end

end
