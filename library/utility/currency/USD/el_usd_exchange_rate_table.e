note
	description: "US Dollor exchange rate table derived from Euro exchange rate"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_USD_EXCHANGE_RATE_TABLE

inherit
	EL_EXCHANGE_RATE_TABLE

create
	make

feature {NONE} -- Constants

	Base_currency: STRING = "USD"

end
