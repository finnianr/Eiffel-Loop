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
	date: "2020-09-15 10:22:46 GMT (Tuesday 15th September 2020)"
	revision: "63"

class
	PAYPAL_STANDARD_BUTTON_MANAGER_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [TUPLE [PAYPAL_TEST_SET]]

create
	make

end