note
	description: "Finalized executable tests for library [./library/currency.html currency.ecf]"
	notes: "[
		Command option: `-currency_autotest'

		**Test Sets**

			[$source CURRENCY_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-04 11:27:26 GMT (Monday 4th October 2021)"
	revision: "1"

class
	CURRENCY_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [CURRENCY_TEST_SET]

create
	make
end