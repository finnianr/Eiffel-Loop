note
	description: "Finalized executable tests for library [./library/currency.html currency.ecf]"
	notes: "[
		Command option: `-currency_autotest'

		**Test Sets**

			${CURRENCY_TEST_SET}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "4"

class
	CURRENCY_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [CURRENCY_TEST_SET]

create
	make
end