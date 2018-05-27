note
	description: "Shared usd exchange rate table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:50 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_SHARED_USD_EXCHANGE_RATE_TABLE

feature {NONE} -- Access

	dollor_rates: EL_USD_EXCHANGE_RATE_TABLE
		do
			Result := US_dollor_daily_rates.today
		end

	previous_dollor_rates: EL_USD_EXCHANGE_RATE_TABLE
		do
			Result := US_dollor_daily_rates.previous
		end

feature {NONE} -- Constants

	US_dollor_daily_rates: EL_USD_DAILY_EXCHANGE_RATES
		once
			create Result.make
		end
end
