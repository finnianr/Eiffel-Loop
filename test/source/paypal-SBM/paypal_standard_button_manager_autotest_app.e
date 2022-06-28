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
	date: "2022-06-25 10:19:42 GMT (Saturday 25th June 2022)"
	revision: "66"

class
	PAYPAL_STANDARD_BUTTON_MANAGER_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [PAYPAL_TEST_SET]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [PP_NAME_TRANSLATER]
		do
			create Result
		end

end