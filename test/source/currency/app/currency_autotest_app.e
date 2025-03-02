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
	date: "2025-03-02 10:49:13 GMT (Sunday 2nd March 2025)"
	revision: "6"

class
	CURRENCY_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_APPLICATION [CURRENCY_TEST_SET]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [
		EL_CURRENCY_LOCALE,
		EL_DAILY_EXCHANGE_RATES [EL_EXCHANGE_RATE_TABLE],
		EL_EURO_DAILY_EXCHANGE_RATES,
		EL_EURO_EXCHANGE_RATE_TABLE,
		EL_EXCHANGE_RATE_TABLE,
		EL_GBP_DAILY_EXCHANGE_RATES,
		EL_GBP_EXCHANGE_RATE_TABLE,
		EL_SHARED_EURO_RATE,
		EL_SHARED_GB_POUND_RATE,
		EL_SHARED_US_DOLLOR_RATE,
		EL_USD_DAILY_EXCHANGE_RATES,
		EL_USD_EXCHANGE_RATE_TABLE
	]
		do
			create Result
		end
end