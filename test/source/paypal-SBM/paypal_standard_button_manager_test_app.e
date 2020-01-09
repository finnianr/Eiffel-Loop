note
	description: "Developer tests for Paypal Stand Button Manager classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 15:53:25 GMT (Wednesday 8th January 2020)"
	revision: "61"

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

	evaluator_type, evaluator_types_all: TUPLE [PAYPAL_TEST_EVALUATOR]
		do
			create Result
		end

feature {NONE} -- Constants

	Option_name: STRING = "paypal_test"

end
