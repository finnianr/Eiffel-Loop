note
	description: "Summary description for {EL_CURRENCY_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-18 10:15:53 GMT (Saturday 18th November 2017)"
	revision: "1"

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
