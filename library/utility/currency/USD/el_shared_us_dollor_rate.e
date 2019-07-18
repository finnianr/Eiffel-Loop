note
	description: "Shared usd exchange rate table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:25:56 GMT (Monday 1st July 2019)"
	revision: "5"

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
