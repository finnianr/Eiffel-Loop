note
	description: "Summary description for {SHARED_CURRENCY_EXCHANGE_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-29 19:11:08 GMT (Wednesday 29th November 2017)"
	revision: "1"

class
	EL_SHARED_EURO_EXCHANGE_RATE_TABLE

feature {NONE} -- Access

	euro_rates: EL_EURO_EXCHANGE_RATE_TABLE
		do
			Result := Euro_daily_rates.today
		end

	previous_euro_rates: EL_EURO_EXCHANGE_RATE_TABLE
		do
			Result := Euro_daily_rates.previous
		end

feature {NONE} -- Constants

	Euro_daily_rates: EL_EURO_DAILY_EXCHANGE_RATES
		once
			create Result.make
		end

end
