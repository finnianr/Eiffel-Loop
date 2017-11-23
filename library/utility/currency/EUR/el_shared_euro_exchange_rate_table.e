note
	description: "Summary description for {SHARED_CURRENCY_EXCHANGE_TABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_SHARED_EURO_EXCHANGE_RATE_TABLE

feature {NONE} -- Access

	euro_rates: EL_EURO_EXCHANGE_RATE_TABLE
		do
			Result := Euro_daily_rates.today
		end

feature {NONE} -- Constants

	Euro_daily_rates: EL_EURO_DAILY_EXCHANGE_RATES
		once
			create Result.make
		end

end
