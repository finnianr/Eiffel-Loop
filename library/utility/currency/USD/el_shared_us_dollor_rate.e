note
	description: "Shared usd exchange rate table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "6"

deferred class
	EL_SHARED_US_DOLLOR_RATE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	US_dollor_rate: EL_USD_DAILY_EXCHANGE_RATES
		once
			create Result.make
		end
end