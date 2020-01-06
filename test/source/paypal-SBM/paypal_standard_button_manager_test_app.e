note
	description: "Developer tests for Paypal Stand Button Manager classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-06 20:08:55 GMT (Monday 6th January 2020)"
	revision: "59"

class
	PAYPAL_STANDARD_BUTTON_MANAGER_TEST_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION
		undefine
			Option_name
		end

create
	make

feature {NONE} -- Implementation

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{PAYPAL_STANDARD_BUTTON_MANAGER_TEST_APP}, All_routines]
			>>
		end

feature {NONE} -- Constants

	Evaluator_types: TUPLE [PAYPAL_TEST_EVALUATOR]
		once
			create Result
		end

	Option_name: STRING = "paypal_test"

end
