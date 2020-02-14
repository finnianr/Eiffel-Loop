note
	description: "[
		Finalized executable tests for Paypal Stand Button Manager library [./library/paypal-SBM.html paypal-SBM.ecf]
	]"
	notes: "[
		Command option: `-paypal_standard_button_manager_autotest'
		
		**Test Sets**
		
			[$source PAYPAL_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-14 13:58:17 GMT (Friday 14th February 2020)"
	revision: "62"

class
	PAYPAL_STANDARD_BUTTON_MANAGER_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	test_type, test_types_all: TUPLE [PAYPAL_TEST_SET]
		do
			create Result
		end

end
