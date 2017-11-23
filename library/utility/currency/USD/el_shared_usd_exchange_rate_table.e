note
	description: "Summary description for {EL_SHARED_USD_EXCHANGE_RATE_TABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_SHARED_USD_EXCHANGE_RATE_TABLE

feature {NONE} -- Access

	dollor_rates: EL_USD_EXCHANGE_RATE_TABLE
		do
			Result := US_dollor_daily_rates.today
		end

feature {NONE} -- Constants

	US_dollor_daily_rates: EL_USD_DAILY_EXCHANGE_RATES
		once
			create Result.make
		end
end
