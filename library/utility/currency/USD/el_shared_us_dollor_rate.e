note
	description: "Shared usd exchange rate table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-16 0:48:12 GMT (Wednesday 16th January 2019)"
	revision: "4"

class
	EL_SHARED_US_DOLLOR_RATE

feature {NONE} -- Constants

	US_dollor_rate: EL_USD_DAILY_EXCHANGE_RATES
		once
			create Result.make
		end
end
