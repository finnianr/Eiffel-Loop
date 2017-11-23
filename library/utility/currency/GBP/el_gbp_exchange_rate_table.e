note
	description: "British Pound exchange rate table derived from Euro exchange rate"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_GBP_EXCHANGE_RATE_TABLE

inherit
	EL_EXCHANGE_RATE_TABLE

create
	make

feature {NONE} -- Constants

	Base_currency: STRING = "GBP"

end
