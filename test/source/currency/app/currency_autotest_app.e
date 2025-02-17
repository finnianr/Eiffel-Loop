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
	date: "2025-02-17 8:51:47 GMT (Monday 17th February 2025)"
	revision: "5"

class
	CURRENCY_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_APPLICATION [CURRENCY_TEST_SET]

create
	make
end