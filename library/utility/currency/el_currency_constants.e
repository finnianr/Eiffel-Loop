note
	description: "Summary description for {EL_CURRENCY_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_CURRENCY_CONSTANTS

feature -- Constants

	Currency_codes: ARRAY [STRING]
		once
			Result := <<
				"AUD", "CAD", "CHF", "CZK", "DKK", "EUR", "GBP", "HKD", "HUF", "ILS", "JPY", "MXN", "NOK", "NZD",
				"PHP", "PLN", "RUB", "SGD", "SEK", "THB", "USD"
			>>
			Result.compare_objects
		end

end
