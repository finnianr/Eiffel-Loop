note
	description: "Summary description for {EL_SHARED_GBP_EXCHANGE_RATE_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-29 19:12:04 GMT (Wednesday 29th November 2017)"
	revision: "1"

class
	EL_SHARED_GBP_EXCHANGE_RATE_TABLE

feature {NONE} -- Access

	pound_rates: EL_GBP_EXCHANGE_RATE_TABLE
		do
			Result := British_pound_daily_rates.today
		end

	previous_pound_rates: EL_GBP_EXCHANGE_RATE_TABLE
		do
			Result := British_pound_daily_rates.previous
		end

feature {NONE} -- Constants

	British_pound_daily_rates: EL_GBP_DAILY_EXCHANGE_RATES
		once
			create Result.make
		end
end
