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
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-06 13:30:28 GMT (Sunday 6th August 2023)"
	revision: "68"

class
	PAYPAL_STANDARD_BUTTON_MANAGER_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [PAYPAL_TEST_SET]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [PP_NAME_TRANSLATER, PP_BUTTON_PARAMETER]
		do
			create Result
		end

end