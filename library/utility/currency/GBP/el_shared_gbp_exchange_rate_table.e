note
	description: "Summary description for {EL_SHARED_GBP_EXCHANGE_RATE_TABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_SHARED_GBP_EXCHANGE_RATE_TABLE

feature {NONE} -- Access

	pound_rates: EL_GBP_EXCHANGE_RATE_TABLE
		do
			Result := British_pound_daily_rates.today
		end

feature {NONE} -- Constants

	British_pound_daily_rates: EL_GBP_DAILY_EXCHANGE_RATES
		once
			create Result.make
		end
end
