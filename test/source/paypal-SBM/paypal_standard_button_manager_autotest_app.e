note
	description: "[
		Finalized executable tests for Paypal Stand Button Manager library [./library/paypal-SBM.html paypal-SBM.ecf]
	]"
	notes: "[
		Command option: `-paypal_standard_button_manager_autotest'
		
		**Test Sets**
		
			${PAYPAL_TEST_SET}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "69"

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